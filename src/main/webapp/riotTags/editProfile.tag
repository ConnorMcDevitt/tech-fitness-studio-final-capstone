<editProfile>
	<div class="content-blocker" onclick={close}>
	
	
		<div onclick = {noPropagate} class="edit-profile">
			<h3>Update Profile</h3> <i onclick= { close } class="em em-x window-close"></i>
			<form onsubmit={editProfile}>
				<label for="name">Name: </label>
				<div><input id="edit-name" type="text" name="name" /></div><br />
		 		<label for="isImperial">Measurement Units: </label>
		 		<div><select id="edit-isImperial" name="isImperial" onchange={changeImperialEdit}>
		 			<option value="T">Imperial</option>
		 			<option value="F">Metric</option>
		 		</select></div><br />
		 		<div class="height-input-edit">
					<label class="height-feet-label">Height: </label>
					<div class="height-input-field-feet"><input id="edit-height-feet" type="text"/> ft.</div>
					<div class="height-input-field-inches"><input id="edit-height-inches" type="text"/> in.</div>
				</div><br />
				<label class="weight-label" for="edit-weight">Current Weight: </label>
				<div class="weight-input-edit"><input id="edit-weight" type="text" name="weight"/> lbs</div><br />
				<label for="edit-gender">Gender: </label>
				<div><input id="edit-gender" type="text" name="gender"></div><br />
				<div class="submitButton"><input type="submit" value="Update"/></div>
			</form>
		</div>
		
	</div>
	
	<script>
		var self = this;
		var jsonResult = null;
		
		bus.on("profileAcquired", function(){
			getProfile();
		});
			
		function getProfile() {
			$.ajax({
				url: BASE_URL + "user/getProfile",
				type: "GET",
				datatype: "json",
			}).done(function(data){
				console.log(data);
				if(data.status === "success"){
					$("#edit-name").val(data.value.name);
					$('#edit-isImperial').val(data.value.isImperial);
					if($('#edit-isImperial').val() === "T") {
						var databaseHeight = data.value.height;
						var feet = Math.floor((+databaseHeight / 2.54) / 12);
						var inches = Math.floor((+databaseHeight / 2.54) % 12);
						var pounds = (+data.value.weight * 2.20462).toFixed(2);
						$("#edit-height-feet").val(feet);
						$("#edit-height-inches").val(inches);
						$("#edit-weight").val(pounds);
					} else {
						$("#edit-height-cm").val(data.value.height);
						$("#edit-weight").val(data.value.weight);
					}
			 		$("#edit-gender").val(data.value.gender);
				}
			}).fail(function(xhr, status, error){
				console.log(error);
			});
		}
	
		close(e) {
			$('editProfile').hide();
		}
		
		noPropagate(e) {
			e.stopPropagation();
		}
		
		editProfile(e) {
			e.preventDefault();
			$.ajax({
				url: BASE_URL + "user/updateProfile",
				type: "POST",
				data: {
					"name" : $('#name').val(),
					"isImperial" : $('#isImperial').val(),
					"height" : height,
					"weight" : weight,
					"gender" : $('#gender').val(),
				},
				datatype: "json",
			}).done(function (data) {
				console.log(data);
				jsonResult = data;
				if(data.status === "success") {
					$('editProfile').hide();
					bus.trigger('profileAcquired');
				}
			}).fail(function(xhr, status, error) {
				console.log(error);
			});
		}
		
		changeImperialEdit() {
			if($('#edit-isImperial').val() === "T") {
				$('.height-input-edit').html('<label class="height-feet-label">Height: </label><div class="height-input-field-feet"><input id="edit-height-feet" type="text"/> ft.</div><div class="height-input-field-inches"><input id="edit-height-inches" type="text"/> in.</div>');
				$('.weight-input-edit').html('<input id="edit-weight" type="text" name="weight"/> lbs');
				getProfile();
			} else {
				$('.height-input-edit').html('<label class="height-cm-label" for="height-cm">Height:</label><div class="height-input-field-cm"><input id="edit-height-cm" type="text"/> cm</div>');
				$('.weight-input-edit').html('<input id="edit-weight" type="text" name="weight"/> kg');
				getProfile();
			}
		}
		
		
		
	</script>

</editProfile>