package controllers

import javax.inject._

import services.NodeCheckinService
import org.joda.time.DateTime
import play.api._
import play.api.libs.functional.syntax._
import play.api.libs.json.{JsPath, Json, Writes}
import play.api.mvc._


@Singleton
class DispatcherController @Inject()(checkinService: NodeCheckinService) extends Controller {

  def poll = Action {
    Ok(Json.obj("results" -> "NA"))
  }

  def pollFromNode(nodeId: Long) = Action {
    Ok
  }

  def pollFromNodeForJob(nodeId: Long, jobId: Long) = Action {
    Ok
  }

}
