class Staff::Admin::CampusLocationsController < Staff::Admin::BaseController
   before_action :set_campus_location, only: [:show, :edit, :update, :destroy]
 
   def index
     @campus_locations = CampusLocation.all
   end
 
   def show
   end
 
   def new
     @campus_location = CampusLocation.new
   end
 
   def create
     @campus_location = CampusLocation.new(campus_location_params)
     if @campus_location.save
       redirect_to staff_admin_campus_locations_path, notice: 'Campus location was successfully created.'
     else
       render :new
     end
   end
 
   def edit
   end
 
   def update
     if @campus_location.update(campus_location_params)
       redirect_to staff_admin_campus_locations_path, notice: 'Campus location was successfully updated.'
     else
       render :edit
     end
   end
 
   def destroy
     @campus_location.destroy
     redirect_to staff_admin_campus_locations_path, notice: 'Campus location was successfully destroyed.'
   end
 
   private
 
   def set_campus_location
     @campus_location = CampusLocation.find(params[:id])
   end
 
   def campus_location_params
     params.require(:campus_location).permit(:name, :address)
   end
 end
 