package controllers

import javax.inject._

import services.NodeService
import entity.Node

import org.joda.time.DateTime
import play.api._
import play.api.libs.functional.syntax._
import play.api.libs.json._
import play.api.mvc._

import scala.concurrent.Await
import scala.concurrent.duration._

@Singleton
class HealthController @Inject()(nodeService: NodeService) extends Controller {

  def index = Action {
    Ok(Json.toJson(Await.result(nodeService.getNodeById(1), 5000 milliseconds)))
  }

  implicit val getAllNodeWrites: Writes[Node] = (
    (JsPath \ "id").write[Long] and
      (JsPath \ "ipAddress").write[String] and
      (JsPath \ "macAddress").write[String] and
      (JsPath \ "name").write[String] and
      (JsPath \ "lastSeen").write[DateTime] and
      (JsPath \ "createdAt").write[DateTime] and
      (JsPath \ "updatedAt").write[DateTime]
    ) (unlift(Node.unapply))
}
