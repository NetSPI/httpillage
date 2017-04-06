package dao

import javax.inject.Inject

import entity.NodeCheckin

import org.joda.time.DateTime
import play.api.db.slick.{DatabaseConfigProvider, HasDatabaseConfigProvider}
import slick.driver.JdbcProfile
import com.github.tototoshi.slick.PostgresJodaSupport._

import scala.concurrent.Future

/**
  * Created by jpoulin on 3/25/17.
  */
class NodeCheckinDAO @Inject()(protected val dbConfigProvider: DatabaseConfigProvider) extends HasDatabaseConfigProvider[JdbcProfile] {
  import driver.api._

  val checkins = TableQuery[CheckinsTable]
  def all(): Future[Seq[NodeCheckin]] = db.run(checkins.result)

  def getCheckinById(id: Long) = db.run(checkins.filter(_.id === id).result.headOption)
  def getCheckinByNodeId(nodeId: Long): Future[Seq[NodeCheckin]] = db.run(checkins.filter(_.nodeId === nodeId).result)
  def getCheckinByJobId(jobId: Long): Future[Seq[NodeCheckin]] = db.run(checkins.filter(_.jobId === jobId).result)

  def create = db.run(DBIO.seq(checkins.schema.create))

  def insert(checkin: NodeCheckin) = db.run(checkins returning checkins.map(n => (n)) += checkin)

  class CheckinsTable(tag: Tag) extends Table[NodeCheckin](tag, "NODECHECKINS") {

    def id = column[Long]("ID", O.PrimaryKey, O.AutoInc)

    def nodeId = column[Long]("NODEID")
    def jobId = column[Long]("JOBID")
    def responseCode = column[Int]("RESPONSECODE")
    def createdAt = column[DateTime]("CREATEDAT")

    def * = (id, nodeId, jobId, responseCode, createdAt) <> (NodeCheckin.tupled, NodeCheckin.unapply _)

  }
}