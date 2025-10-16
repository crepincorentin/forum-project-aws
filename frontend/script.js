const API_URL = 'http://localhost:3000'; // à adapter plus tard sur AWS

async function fetchMessages() {
  try {
    const res = await fetch(`${API_URL}/messages`);
    const messages = await res.json();

    const messagesDiv = document.getElementById('messages');
    messagesDiv.innerHTML = '';

    messages.forEach(msg => {
      const el = document.createElement('div');
      el.classList.add('message');
      el.innerHTML = `
        <div class="pseudo">@${msg.pseudonyme}</div>
        <div class="contenu">${msg.contenu}</div>
        <div class="date">${new Date(msg.created_at).toLocaleString()}</div>
      `;
      messagesDiv.appendChild(el);
    });
  } catch (err) {
    console.error('Erreur chargement messages:', err);
  }
}

document.getElementById('form').addEventListener('submit', async e => {
  e.preventDefault();

  const pseudonyme = document.getElementById('pseudo').value.trim();
  const contenu = document.getElementById('message').value.trim();
  if (!pseudonyme || !contenu) return;

  await fetch(`${API_URL}/messages`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ pseudonyme, contenu }),
  });

  document.getElementById('message').value = '';
  await fetchMessages();
});

fetchMessages();
