# Found Phone Template For Godot 🚧 WORK IN PROGRESS 🚧

![Godot 4](https://img.shields.io/badge/Godot-v4.x-%23478cbf?logo=godot-engine&logoColor=white)
![Status](https://img.shields.io/badge/Status-In%20Development-orange)
![License](https://img.shields.io/badge/License-MIT-green)

<p align="center">
  <img src="https://github.com/user-attachments/assets/0de0fd0b-26b1-48bb-be32-7c37c1c98e1e" alt="Home Screen" width="30%">
  <img src="https://github.com/user-attachments/assets/2540a4b4-1de2-4fc2-a4bb-8f9f813b9ab3" alt="Chat UI" width="30%">
  <img src="https://github.com/user-attachments/assets/2652e201-e6cf-4250-bf5a-7a66f3a83fed" alt="Gallery UI" width="30%"/>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/fc5d508f-963e-40f1-8a52-8ad286806369" alt="Call UI" width="30%">
  <img src="https://github.com/user-attachments/assets/02964240-f90e-4d3b-8b6d-2e4cd1a31cca" alt="Web Browser UI" width="30%">
</p>

An open-source template designed to create narrative "Found Phone" games (similar to *Simulacra*, *A Normal Lost Phone*, or *Duskwood*) using **Godot Engine 4**.

The project is currently in early development. The focus is on building the core logic for standard apps first. Future updates will focus on UI polishing and optimizing the content creation workflow for ease of use.
## Roadmap

### Phase 1
- [x] Core OS UI & Notch Handling
- [x] Chat App (Reading & Branching Choices)
- [x] Chat App (Images & Audio support)
- [x] Photo Gallery App
- [x] Incoming Call System
- [x] Notification System
- [x] Web Browser Simulation

### Phase 2
#### Improvements & Refactoring
- [x] Migrate chat loading to `PlayerData.gd` to treat them as unlockable and dynamic resources
- [ ] Centralize unlock events to impact state first and then update the UI
- [ ] Implement message tracking for persistence and visual alerts (Badges)
- [ ] Adapt data resources to integrate with Godot's native translation system
#### New Features
- [ ] Save & Load System
- [ ] Video Support
- [ ] Lock Screen / PIN System
- [ ] Settings App
- [ ] Email App
- [ ] Phone App

## Getting Started

>Note: This workflow is experimental and will likely change as the template evolves.

### 1. Creating Conversations

- **Messages:** Create a `MessageData` resource. Set text, media, sender, and delay.
- **Branching Paths:** In any `MessageData`, add `ReplyOption` resources to the `Reply Options` array. Link each option to the next `MessageData` file.
- **Chat Container:** Create a `ChatData` resource and drag the initial messages into the array. The system automatically populates the chat list from these files.

### 2. Creating Web Pages
The Web Browser loads actual Godot scenes, allowing for custom interaction.

1. **Create the Scene:** Create a new web page scene and set its root script to extend `WebPage`.
2. **Handle Interactivity (Signals):**
   - **Navigate:** To go to another URL, use `navigate_to_url_requested.emit("target_url.com")`.
   - **Trigger Events:** To trigger a story event (like a call or unlock), use `trigger_event_requested.emit(event_resource)`.
3. **Register Page:** 
   - Create a `WebpageData` resource pointing to your scene and giving it a URL.
   - Register the URL in `_System/_Autoloads/web_manager.gd` under the `url_registry` dictionary.

### 3. Story Events
`StoryEvent` resources allow you to trigger actions from anywhere (e.g., from a message arrival or a button on a website).
- **Types:** `INCOMING_CALL`, `UNLOCK_PHOTO`, `NOTIFICATION`.
- **Usage:** Set the `Type`, the `Target Resource` (e.g., a `ContactData` for calls or `PhotoData` for unlocks), and an optional `Delay`.

## Project Structure

- `_Assets/`: Images, Fonts, and Icons for the system OS.
- `_System/`: Contains the system logic (Scripts, Base Scenes, System definitions).
- `Apps/`: Individual simulated applications (Chat, Gallery, Settings). You can create new apps and simply link them to an icon in the HomeApp.
- `GameContent/`
  - `Assets/`: Story-specific assets like Images or Audios.
  - `Data/`: `.tres` resources like `ChatData`, `MessageData` or `PhotoData`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
