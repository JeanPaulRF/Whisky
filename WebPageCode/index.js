function handleSubmit () {
   const name = document.getElementById('username').value;
   const password = document.getElementById('password').value;

   // to set into local storage
   localStorage.setItem("USERNAME", name);
   localStorage.setItem("PASSWORD", password );
   
   sessionStorage.setItem("USERNAME", name);
   sessionStorage.setItem("PASSWORD", password );

   return;
}