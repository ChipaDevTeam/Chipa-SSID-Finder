# Chipa SSID Finder - Website Documentation

This directory contains the static website for Chipa SSID Finder, designed to be hosted on GitHub Pages for Google Play Console deployment.

## 📁 Structure

```
docs/
├── index.html              # Homepage
├── about.html              # About page
├── features.html           # Features page
├── privacy-policy.html     # Privacy Policy (required for Google Play)
├── terms.html              # Terms of Service
├── disclaimer.html         # Disclaimer
├── contact.html            # Contact page
├── css/
│   └── style.css          # Main stylesheet
└── images/
    ├── logo.png           # App logo (512x512)
    └── feature-graphic.png # Feature graphic
```

## 🚀 Deployment to GitHub Pages

### Step 1: Enable GitHub Pages

1. Go to your repository settings on GitHub
2. Navigate to **Pages** section
3. Under "Source", select **main** branch
4. Select **/docs** folder
5. Click **Save**

### Step 2: Access Your Website

Your website will be available at:
```
https://theshadow76.github.io/Chipa-SSID-Finder/
```

### Step 3: Use in Google Play Console

Privacy Policy URL for Google Play:
```
https://theshadow76.github.io/Chipa-SSID-Finder/privacy-policy.html
```

Terms of Service URL:
```
https://theshadow76.github.io/Chipa-SSID-Finder/terms.html
```

## 📝 Pages Overview

### Homepage (index.html)
- Hero section with app description
- Key features grid
- Supported platforms
- How it works (5 steps)
- Download section
- Full navigation

### About (about.html)
- What is the app
- Mission and vision
- Technology stack
- Supported platforms
- Contributing information
- Open source details

### Features (features.html)
- Detailed feature list
- Privacy & security features
- Performance highlights
- UI/UX features
- Platform support
- Comparison table

### Privacy Policy (privacy-policy.html)
- Complete privacy policy
- Data collection (none)
- Permissions explained
- Security practices
- User rights
- GDPR/CCPA compliance
- **Required for Google Play Store**

### Terms of Service (terms.html)
- Terms and conditions
- User responsibilities
- License information
- Liability limitations
- Platform disclaimers
- Legal compliance

### Disclaimer (disclaimer.html)
- No affiliation disclaimer
- Risk warnings
- Liability limitations
- Security disclaimers
- Legal compliance notes

### Contact (contact.html)
- Contact form (Formspree integration ready)
- Bug report links
- Feature request links
- GitHub links
- Support resources

## 🎨 Customization

### Colors
Edit `css/style.css` to change the color scheme:
```css
:root {
  --primary-color: #6B46C1;     /* Purple */
  --secondary-color: #9333EA;    /* Lighter purple */
  --accent-color: #A78BFA;       /* Accent */
}
```

### Logo
Replace `images/logo.png` with your own logo (recommended size: 512x512px)

### Contact Form
Update the form action in `contact.html`:
```html
<form action="https://formspree.io/f/YOUR_FORM_ID" method="POST">
```

Get a form ID from: https://formspree.io/

## ✅ Google Play Console Requirements

This website provides all required pages for Google Play:

- ✅ **Privacy Policy** - privacy-policy.html
- ✅ **Terms of Service** - terms.html  
- ✅ **Contact Information** - contact.html
- ✅ **App Description** - about.html
- ✅ **Feature List** - features.html

## 🔧 Local Development

To test locally:

```bash
# Using Python 3
cd docs
python3 -m http.server 8000

# Then open: http://localhost:8000
```

Or use any static file server:
```bash
# Using Node.js
npx serve docs

# Using PHP
cd docs && php -S localhost:8000
```

## 📱 Mobile Responsive

All pages are fully responsive and work on:
- ✅ Mobile phones (320px+)
- ✅ Tablets (768px+)
- ✅ Desktops (1024px+)

## 🔍 SEO Optimized

Each page includes:
- Meta descriptions
- Keywords
- Open Graph tags ready to add
- Semantic HTML
- Fast loading times

## 🚀 Performance

- Minimal CSS (single file)
- No external dependencies
- No JavaScript frameworks
- Fast loading (<1s)
- Optimized images

## 📊 Analytics (Optional)

To add Google Analytics, insert before `</head>` in each HTML file:

```html
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

## ✨ Features

- 🎨 Modern Material Design 3 style
- 📱 Fully responsive
- ⚡ Fast loading
- 🔒 Privacy-focused
- ♿ Accessible
- 🌐 SEO optimized
- 🎯 Call-to-action buttons
- 📝 Complete documentation
- 🔗 Easy navigation
- 💜 Purple gradient theme

## 🐛 Troubleshooting

### GitHub Pages not working?
1. Check repository settings > Pages
2. Ensure `/docs` folder is selected
3. Wait 2-5 minutes for deployment
4. Check `https://theshadow76.github.io/Chipa-SSID-Finder/`

### Styles not loading?
- Ensure `css/style.css` path is correct
- Check browser console for errors
- Clear browser cache

### Images not showing?
- Verify images are in `docs/images/`
- Check file names match HTML references
- Ensure images are committed to GitHub

## 📧 Support

- **GitHub Issues**: https://github.com/theshadow76/Chipa-SSID-Finder/issues
- **Email**: Use contact form on website
- **Discussions**: https://github.com/theshadow76/Chipa-SSID-Finder/discussions

## 📄 License

This website is part of the Chipa SSID Finder project and is licensed under the MIT License.

---

**Ready to Deploy!** 🚀

Commit the `/docs` folder to GitHub, enable Pages, and your website will be live!
