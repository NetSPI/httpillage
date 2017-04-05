package controllers

import javax.inject._

import play.api._
import play.api.libs.json.Json
import play.api.mvc._

@Singleton
class DispatcherController @Inject() extends Controller {

  def poll = Action {
    Ok(Json.obj("results" -> "NA"))
  }

  def pollFromNode(nodeId: Int) = Action {
    Ok
  }

  def pollFromNodeForJob(nodeId: Int, jobId: Int) = Action {
    Ok
  }

  def checkin(nodeId: Int, jobId: Int, statusCode: Int) = Action {
    Ok
  }
}
