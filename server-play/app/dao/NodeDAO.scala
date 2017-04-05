package dao

import javax.inject.Inject

import entity.Node
import org.joda.time.DateTime
import play.api.db.slick.{DatabaseConfigProvider, HasDatabaseConfigProvider}
import slick.driver.JdbcProfile
import com.github.tototoshi.slick.PostgresJodaSupport._

import scala.concurrent.Future

/**
  * Created by jpoulin on 3/25/17.
  */
class NodeDAO @Inject()(protected val dbConfigProvider: DatabaseConfigProvider) extends HasDatabaseConfigProvider[JdbcProfile] {
  import driver.api._

  val nodes = TableQuery[NodesTable]
  def all(): Future[Seq[Node]] = db.run(nodes.result)

  def getNodeById(id: Long) = db.run(nodes.filter(_.id === id).result.headOption)

  def create = db.run(DBIO.seq(nodes.schema.create))

  def insert(node: Node) = db.run(nodes returning nodes.map(n => (n)) += node)

  class NodesTable(tag: Tag) extends Table[Node](tag, "NODES") {

    def id = column[Long]("ID", O.PrimaryKey, O.AutoInc)

    def ipAddress = column[String]("IPADDRESS")
    def macAddress = column[String]("MACADDRESS")
    def name = column[String]("NAME")
    def lastSeen = column[DateTime]("LASTSEEN")
    def createdAt = column[DateTime]("CREATEDAT")
    def updatedAt = column[DateTime]("UPDATEDAT")

    def * = (id, ipAddress, macAddress, name, lastSeen, createdAt, updatedAt) <> (Node.tupled, Node.unapply _)

  }
}
