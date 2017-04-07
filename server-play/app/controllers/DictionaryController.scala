package controllers

import javax.inject._

import entity.Dictionary
import org.joda.time.DateTime
import play.api._
import play.api.libs.json._
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

  def createDictionary() = Action.async(parse.json) {
    request =>
      import scala.concurrent.ExecutionContext.Implicits.global

      val json = request.body.validate[CreateDictionary]
      json.fold(
        invalid => {
          Future(BadRequest(Json.obj("status" -> "KO", "message" -> JsError.toJson(invalid))))
        },
        valid => {

          val dictionary = Dictionary(
            -999,
            json.get.filename,
            json.get.originalFilename,
            json.get.description,
            json.get.sizeInBytes,
            DateTime.now,
            DateTime.now
          )

          dictionaryService.createDictionary(dictionary).map(d => Ok(Json.toJson(d)))
        }
      )
  }

  def deleteDictionary(dictionaryId: Long) = Action.async {
    request =>
      import scala.concurrent.ExecutionContext.Implicits.global

      dictionaryService.deleteDictionary(dictionaryId).map(_ => Ok)
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

  implicit val dictionaryWrite: Reads[CreateDictionary] = (
      (JsPath \ "fileName").read[String] and
      (JsPath \ "originalFilename").read[String] and
      (JsPath \ "description").read[String] and
      (JsPath \ "sizeInBytes").read[Long] and
      (JsPath \ "createdAt").read[DateTime] and
      (JsPath \ "updatedAt").read[DateTime]
    ) (CreateDictionary.apply _)

}

case class CreateDictionary(
                            filename: String,
                            originalFilename: String,
                            description: String,
                            sizeInBytes: Long,
                            createdAt: DateTime,
                            updatedAt: DateTime
                           )
