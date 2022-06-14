window.addEventListener('load', () => {
   const params = (new URL (document.location)).searchParams;
   const username = params.get('username');
   const password = params.get('password');

   document.getElementById('result-username').innerHTML = username;
   document.getElementById('result-password').innerHTML = password;

})