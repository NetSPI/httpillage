package controllers

import javax.inject._

import play.api._
import play.api.libs.json.Json
import play.api.mvc._

@Singleton
class JobResponseController @Inject() extends Controller {

  def create(jobId: Int) = Action {
    Ok
  }

  def getResponses(jobId: Int) = Action {
    Ok
  }

  def getResponse(jobId: Int, responseId: Int) = Action {
    Ok
  }
}
