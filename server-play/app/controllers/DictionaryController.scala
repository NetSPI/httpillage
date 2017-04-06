package controllers

import javax.inject._

import entity.Dictionary
import org.joda.time.DateTime
import play.api._
import play.api.libs.json.{JsPath, Json, Writes}
import play.api.libs.functional.syntax._
import play.api.mvc._
import services.DictionaryService

import scala.concurrent.{Await, Future}
import scala.concurrent.duration._

@Singleton
class DictionaryController @Inject()(dictionaryService: DictionaryService) extends Controller {

  def index = Action {
    Ok(Json.toJson(Await.result(dictionaryService.getDictionaries, 5000 milliseconds)))
  }

  def getDictionary(dictionaryId: Long) = Action {
    Ok(Json.toJson(Await.result(dictionaryService.getDictionaryById(dictionaryId), 5000 milliseconds)))
  }

  def create = Action {
    Ok
  }

  def deleteDictionary(dictionaryId: Long) = Action {
    Ok
  }

  implicit val getAllDictionaryWrites: Writes[Dictionary] = (
    (JsPath \ "id").write[Long] and
      (JsPath \ "fileName").write[String] and
      (JsPath \ "originalFileName").write[String] and
      (JsPath \ "description").write[String] and
      (JsPath \ "sizeInBytes").write[Long] and
      (JsPath \ "createdAt").write[DateTime] and
      (JsPath \ "updatedAt").write[DateTime]
    ) (unlift(Dictionary.unapply))
}
