# Flameworld

**A tiny flame. A tiny planet. Burn absolutely everything.**

A cozy roguelike game where you play as a mischievous living flame exploring a spherical fantasy planet, burning everything in your path and creating massive chain reactions.

## Play Online

The game is deployed at: [GitHub Pages URL will be available after first deployment]

## Game Concept

You are a tiny flame that burns whatever it touches. Explore a procedurally generated spherical planet, create chain reactions, collect Embers, and grow bigger and slower. But beware - water enemies will chase you, and one splash means game over!

### Core Mechanics

- **Touch to Burn**: Your flame automatically burns anything it touches
- **Chain Reactions**: Create massive cascading fires by burning objects strategically
- **Growth System**: Collect Embers to grow through 6 stages (Spark → Flame → Blaze → Inferno → Wildfire → Cataclysm)
- **Speed Trade-off**: As you grow bigger, you move slower but can burn larger objects
- **Spherical Planet**: The world wraps around - walk far enough and you'll come back from the other side
- **Roguelike Elements**: Each run is unique with procedurally generated planets

### Controls

**Desktop:**
- WASD or Arrow Keys to move

**Mobile:**
- Touch anywhere on screen to move towards that location

### Object Types

- **Grass** (5 Embers): Burns fast, spreads quickly
- **Trees** (50 Embers): Burns slowly, spreads far
- **Houses** (200 Embers): Valuable, spreads to nearby structures
- **Mushrooms** (30 Embers): Creates explosive chain reactions

### Enemies

- **Rain Sprites**: Chase you with water buckets
- More enemy types coming soon!

## Development

### Prerequisites

- Godot 4.3 or later

### Running Locally

1. Clone the repository
2. Open the project in Godot
3. Press F5 to run

### Building for Web

```bash
godot --headless --export-release "Web" build/web/index.html
```

## CI/CD

The game automatically builds and deploys to GitHub Pages when you push to the main branch.

### Setting up GitHub Pages

1. Go to your repository Settings
2. Navigate to Pages
3. Under "Build and deployment", select "GitHub Actions" as the source
4. Push to main branch to trigger the deployment

## Game Design

Based on the game concept document, this is a cozy roguelike about:
- Creating beautiful destruction
- Strategic fire propagation
- Growing from a tiny spark to a massive cataclysm
- Surviving water-based enemies
- Exploring procedurally generated fantasy planets

## Technologies

- **Engine**: Godot 4.3
- **Language**: GDScript
- **CI/CD**: GitHub Actions
- **Deployment**: GitHub Pages

## License

This project is open source and available under the MIT License.
