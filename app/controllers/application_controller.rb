class ApplicationController < ActionController::Base
    include SessionsHelper # Add session helpers to all controllers so they can use helper methods like login, logout, etc.
    include ApplicationHelper # Add helpers applicable to all controllers

end
