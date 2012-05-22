# -*- encoding : utf-8 -*-
class RestExamplesController < ApplicationController
  # GET /rest_examples
  # GET /rest_examples.xml
  def index
    @rest_examples = RestExample.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rest_examples }
    end
  end

  # GET /rest_examples/1
  # GET /rest_examples/1.xml
  def show
    @rest_example = RestExample.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rest_example }
    end
  end

  # GET /rest_examples/new
  # GET /rest_examples/new.xml
  def new
    @rest_example = RestExample.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rest_example }
    end
  end

  # GET /rest_examples/1/edit
  def edit
    @rest_example = RestExample.find(params[:id])
  end

  # POST /rest_examples
  # POST /rest_examples.xml
  def create
    @rest_example = RestExample.new(params[:rest_example])

    respond_to do |format|
      if @rest_example.save
        format.html { redirect_to(@rest_example, :notice => 'RestExample was successfully created.') }
        format.xml  { render :xml => @rest_example, :status => :created, :location => @rest_example }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rest_example.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rest_examples/1
  # PUT /rest_examples/1.xml
  def update
    @rest_example = RestExample.find(params[:id])

    respond_to do |format|
      if @rest_example.update_attributes(params[:rest_example])
        format.html { redirect_to(@rest_example, :notice => 'RestExample was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rest_example.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rest_examples/1
  # DELETE /rest_examples/1.xml
  def destroy
    @rest_example = RestExample.find(params[:id])
    @rest_example.destroy

    respond_to do |format|
      format.html { redirect_to(rest_examples_url) }
      format.xml  { head :ok }
    end
  end
end
