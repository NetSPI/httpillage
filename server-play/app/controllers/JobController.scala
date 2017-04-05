package controllers

import javax.inject._

import play.api._
import play.api.libs.json.Json
import play.api.mvc._

@Singleton
class JobController @Inject() extends Controller {

  def index = Action {
    Ok(Json.obj("status" -> "ok"))
  }

  def getJob(jobId: Int) = Action {
    Ok
  }

  def create = Action {
    Ok
  }

  def updateJob(jobId: Int) = Action {
    Ok
  }

  def deleteJob(jobId: Int) = Action {
    Ok
  }
}
