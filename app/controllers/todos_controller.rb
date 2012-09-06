class TodosController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :require_user
  #fetch all records
  def index
	#completed todo task
	if params[:id]
		task_completed(params[:id])
	end

	#create new todo
	if params[:todo]
		create_new_todo(params[:todo])
	else
		@o_single = Todo.new
	end

	#shared todo with other user
	unless params[:user].blank?
		unless params[:user][:email].blank?
			share_todo_with_user(params[:user][:email])
		else
			flash[:error_message] = "Email address required."
		end
	end
	
    # pending and completed todos 
	pending_completed_tasks_list(params[:search], params[:page])

	#collaborators todos
	collaborators_todos

	#all collaborators
	@collaborators = TodoShare.all_users(current_user.id)
  end
  
  #fetch single record and display
  def show
    @o_single = Todo.find(params[:id])
  end
  
  #generate a form for new record
  def new
    @o_single = Todo.new
  end
  
  #create a new record and save in database
  def create
    @o_single = Todo.new(params[:todo])
    if @o_single.save
      flash[:notice] = "successfully_created"
      redirect_to todos_path
    else
      render :action => 'new'
    end
  end
  
  #generate a edit form to update the record
  def edit
    @o_single = Todo.find(params[:id])
  end
  
  #update a record and save in database
  def update
    @o_single = Todo.find(params[:id])
    if @o_single.update_attributes(params[:todo])
      flash[:notice] = "successfully_updated"
      redirect_to todos_path
    else
      render :action => 'edit'
    end
  end
  
  #destoy a pending record
  def destroy_todo
	remove_todos(params[:id])
	pending_completed_tasks_list(params[:search], params[:page])

  end

  #destoy a completed record
  def destroy_completed_todo
	remove_todos(params[:id])
	pending_completed_tasks_list(params[:search], params[:page])
  end

  #destoy a record
  def stop_share_list
    @o_single = TodoShare.find(params[:id])
    @o_single.destroy
    flash[:completed_todo] = "Successfully stoped sharing list"
	#all collaborators
	@collaborators = TodoShare.all_users(current_user.id)
  end

  def make_completed
	if params[:id]
		task_completed(params[:id])
	end
	if params[:step] == 'one'
		pending_completed_tasks_list(params[:search], params[:page])
	else
		collaborators_todos
	end
  end   


  private
  def pending_completed_tasks_list(search, pagen)
	#pending todos 	
    @o_all_pending = Todo.search_pending(search, current_user.id).order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => pagen)
	#completed todos

    @o_all_completed = Todo.search_completed(search, current_user.id).order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => pagen)
  end

  def remove_todos(id)
    @o_single = Todo.find(id)
    @o_single.destroy
    flash[:completed_todo] = "successfully destroyed"
  end

  def task_completed(id)
	@o_make_completed = Todo.find(id)
	@o_make_completed.status = 'done'
	@o_make_completed.completed_user_id = current_user.id
	@o_make_completed.save
	flash[:completed_todo] = @o_make_completed.title + " successfully completed"
  end

  def create_new_todo(todos_param)

	if !todos_param[:id].blank?
	    @o_single = Todo.find(todos_param[:id])
    	if @o_single.update_attributes(todos_param)
			flash[:success_todo] = "Todo updated"
		end
	else
		@o_single = Todo.new(todos_param)
		if @o_single.save
			flash[:success_todo] = "New todo created"
		end
	end

  end

  def share_todo_with_user(email)
	@o_user = User.find_by_email(email)
	if @o_user
		@o_todo_share = TodoShare.new
		@o_todo_share.share_user_id = @o_user.id
		@o_todo_share.user_id = current_user.id
		@o_todo_share.save
		flash[:success_todo] = 'Todo lists shared successfully with ' + @o_user.email
	else
		flash[:error_message] = "Email address is not exist."
	end 
  end

  def collaborators_todos
    @o_all_shared = TodoShare.where(:share_user_id => current_user.id)
	@all_shared_todos = Hash.new
	@o_all_shared.each do |o_row|
		@o_user_todos = Todo.where("user_id = ? AND status IS NULL", o_row.user_id)
		@all_shared_todos[User.find(o_row.user_id).email] = @o_user_todos
	end 
  end

  #sort column private method
  def sort_column
    Todo.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  #order records private method
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
