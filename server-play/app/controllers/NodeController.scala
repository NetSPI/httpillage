package controllers

import javax.inject._

import entity.Node
import org.joda.time.DateTime
import play.api._
import play.api.libs.functional.syntax._
import play.api.libs.json._
import play.api.mvc._
import services.NodeService

import scala.concurrent.Await
import scala.concurrent.duration._

@Singleton
class NodeController @Inject()(nodeService: NodeService) extends Controller {

  def index = Action {
      Ok(Json.toJson(Await.result(nodeService.getNodes, 5000 milliseconds)))
  }

  def getNodeById(nodeId: Long) = Action {
    Ok(Json.toJson(Await.result(nodeService.getNodeById(nodeId), 5000 milliseconds)))
  }

  implicit val getAllNodeWrites: Writes[entity.Node] = (
    (JsPath \ "id").write[Long] and
      (JsPath \ "ipAddress").write[String] and
      (JsPath \ "macAddress").write[String] and
      (JsPath \ "name").write[String] and
      (JsPath \ "lastSeen").write[DateTime] and
      (JsPath \ "createdAt").write[DateTime] and
      (JsPath \ "updatedAt").write[DateTime]
    ) (unlift(Node.unapply))
}
