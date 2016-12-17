<?php
 /** Connect to DB */
$servername = "localhost";
$username = "phpwebuser";
$password = "";

// Create connection
$conn = new mysqli($servername, $username, $password);

// Check connection
if ($conn->connect_error) 
{
    die("Connection failed: " . $conn->connect_error);
} 

//echo "Connected successfully <br>";
$conn->query("use Records");

?>
<!-- Show Database Button -->
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
<div class="codebox">

<dt style="text-align: center;">
<input type="button" value="Show Video Database" class="btn btn2 btn-outline btn-xl page-scroll" 

onclick="var spoiler = $(this).parents('.codebox').find('.content').toggle('slow');

if ( this.value == 'Hide Video Database' ) 
{ 
	this.value = 'Show Video Database'; 
} 
else 
{ 
	this.value = 'Hide Video Database'; 
};
return false;"></dt>

<dd><div class="content" name="spoiler" style="display: none;">
<?php
	/** Display Video Database */
	$sql = "SELECT EntryID, VideoPath, RecordDateTime FROM Records";
	$result = $conn->query($sql);
	
if ($result->num_rows > 0) 
{
// output data of each row
	
	echo "<h1>Video Database</h1>
			<table style=\"width:100%\">
		  <tr>
			<th>Number</th>
			<th>Record Date</th> 
			<th>Video</th>
		  </tr>";
		  
	$killdb = false;
  
  	if(isset($_POST['ja'])) 
	{ 
		$killdb = true;
	} 
	else 
	{ 
		$killdb = false;
	}
	
	/*
	if($killdb)
	{
		$sql = "DELETE FROM Records where VideoPath = NULL";
		$conn->query($sql);
		
		$sql = "SELECT VideoPath, RecordDateTime FROM Records";
		$result = $conn->query($sql);
	}*/
	
	
	$i = 0;
    while($row = $result->fetch_assoc()) 
	{
		$i++;
		if($killdb && $row["VideoPath"] == NULL)
		{
			
			//echo "<tr><td>" . $i . "</td>";
			//echo "<td>" . $row["RecordDateTime"]. "</td>";
		}
		else
		{
			echo "<tr><td>" . $i . "</td>";
			echo "<td>" . $row["RecordDateTime"]. "</td>";
		}

		if($killdb && $row["VideoPath"] == NULL)
		{
			$sql = "DELETE FROM Records where EntryID =" . $row["EntryID"];
			$conn->query($sql);
		}

		/** Display Video Rows*/
		if( $row["VideoPath"] != null)
		{
			echo " <td> <a class=\"btn btn-outline btn-outlineEnt btn-xl page-scroll\" href=\"#" .$i . "\">"; 
			
			echo "Available";

			echo "</a></td></tr>";
		}
		else
		{	
			if(!$killdb)	
			{
				echo "<td><a class=\"btn btn-outlineDel btn-xl\">deleted</a><td>";
			}	
		}
    }



} 
else 
{
	echo "0 results";
}

?>
<!-- Show Database Del Button -->
  </table>
  
    <h4>delete old entries</h4>
  <form action='./#records' method='POST' > 
	<input type="submit" value="Ja" name="ja" class="btn btn2 btn-outline btn-xl page-scroll" /> 
	<input type="submit" value="Nein" name="nein" class="btn btn2 btn-outline btn-xl page-scroll" /> 
  </form> 
	
</div></dd></div>

<?php
	/** Display Videos */
$sql = "SELECT VideoPath, RecordDateTime FROM Records";
$result = $conn->query($sql);

$i = 0;

if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        $i++;
		if($row["VideoPath"] != null)
		{	
			echo "    <section id=\"" ."$i". "\">";
			
			echo "<h2>";
			echo "
			<video width=\"100%\" height=\"auto\" controls>
				<source src=\"Videos/". $row["VideoPath"]."\" type=\"video/mp4\">
				Your browser does not support the video tag.
			</video>";
		
			echo "<h3>Date " . $row["RecordDateTime"]. "</h3><br><br>";
			
			echo "</section>";
		}

    }
} 
else 
{
    echo "0 results";
}
$conn->close();
?>

