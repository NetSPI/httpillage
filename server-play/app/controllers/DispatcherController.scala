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

  def pollFromNode(nodeId: Long) = Action {
    Ok
  }

  def pollFromNodeForJob(nodeId: Long, jobId: Long) = Action {
    Ok
  }

  def checkin(nodeId: Long, jobId: Long, statusCode: Long) = Action {
    Ok
  }
}
