// Dark mode toggle
const darkToggle = document.getElementById("darkModeToggle");
darkToggle.addEventListener("click", () => {
  document.body.classList.toggle("dark");
  darkToggle.textContent = document.body.classList.contains("dark") ? "☀️" : "🌙";
});

// Hamburger menu toggle
const menuToggle = document.querySelector(".menu-toggle");
const nav = document.querySelector("nav");

menuToggle.addEventListener("click", () => {
  nav.classList.toggle("show");
});

(function(){
      const gallery = document.getElementById('gallery');
      const lightbox = document.getElementById('lightbox');
      const lightboxImg = document.getElementById('lightboxImg');
      const caption = document.getElementById('caption');
      const closeBtn = document.getElementById('closeBtn');
      const prevBtn = document.getElementById('prevBtn');
      const nextBtn = document.getElementById('nextBtn');

      const thumbs = Array.from(gallery.querySelectorAll('.thumb'));
      let currentIndex = -1;

      function open(index){
        const thumb = thumbs[index];
        if(!thumb) return;
        const full = thumb.getAttribute('data-full');
        const cap = thumb.getAttribute('data-caption') || '';
        const alt = thumb.querySelector('img')?.alt || '';
        lightboxImg.src = full;
        lightboxImg.alt = alt;
        caption.textContent = cap;
        lightbox.classList.add('open');
        lightbox.setAttribute('aria-hidden','false');
        currentIndex = index;
        closeBtn.focus();
      }

      function close(){
        lightbox.classList.remove('open');
        lightbox.setAttribute('aria-hidden','true');
        lightboxImg.src = '';
        currentIndex = -1;
      }

      function showNext(dir){
        if(currentIndex < 0) return;
        let nextIndex = (currentIndex + dir + thumbs.length) % thumbs.length;
        open(nextIndex);
      }

      thumbs.forEach((fig, i)=>{
        fig.addEventListener('click', ()=>open(i));
        fig.addEventListener('keydown', (e)=>{ if(e.key === 'Enter' || e.key === ' ') { e.preventDefault(); open(i); } });
      });

      closeBtn.addEventListener('click', close);
      prevBtn.addEventListener('click', ()=>showNext(-1));
      nextBtn.addEventListener('click', ()=>showNext(1));

      lightbox.addEventListener('click', (e)=>{ if(e.target === lightbox) close(); });

      document.addEventListener('keydown', (e)=>{
        if(lightbox.classList.contains('open')){
          if(e.key === 'Escape') close();
          if(e.key === 'ArrowLeft') showNext(-1);
          if(e.key === 'ArrowRight') showNext(1);
        }
      });
    })();