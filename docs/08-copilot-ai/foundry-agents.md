# Azure AI Foundry Agents in Teams

## Overview

Microsoft Foundry (formerly Azure AI Studio / Azure AI Foundry) provides two primary agent types that can surface in Microsoft Teams meetings:

## Agent Types

### Declarative Agents

- Use Copilot's built-in orchestration engine
- Developer defines purpose, grounding knowledge sources, and tool access in a declarative schema
- Platform handles orchestration and execution
- Best for extending Copilot's capabilities with custom knowledge or APIs
- One-click publishing from Foundry to M365 Copilot and Teams Chat

### Custom Engine Agents (CEAs)

- Bring your own orchestrator and models
- Architecture: M365 Copilot receives user input → Azure Bot Service delivers activities → proxy agent handles orchestration → your backend executes the workflow
- Full control over prompts, tools, and model selection
- Supports TypeScript and Python implementations
- Can surface across Copilot, Teams chat, web, and other channels

## Teams Meeting Integration

Custom Engine Agents can operate within Teams channels and meetings:

- Respond to `@mentions` in meeting chat
- Process meeting context and provide responses
- Published to Teams via Azure Bot Service

**Current limitation:** There is no direct first-party integration path for custom Foundry agents to appear on the Teams Rooms front-of-room display or touch console. Agents interact through the Teams meeting chat. In-room participants see agent responses in the chat on the touch console, but there is no dedicated agent panel on the front-of-room display.

The Facilitator agent is currently the only AI agent with a native front-of-room display experience on Teams Rooms hardware.

## Practical Architecture

For conference room AI initiatives, the realistic path is:

1. Build custom engine agents in Foundry Agent Service using your models and orchestration
2. Publish to Teams via Azure Bot Service with one-click deployment
3. Agents participate in meetings through the chat channel
4. In-room participants interact via the touch console's chat or their personal devices
5. Post-meeting, agents can process transcripts and recordings via Graph API for automated workflows

**Memory in Foundry Agent Service** provides a fully managed long-term memory store integrated with the agent runtime, enabling context persistence across sessions and devices.

## Related Topics

- [Copilot Overview](copilot-overview.md) — M365 Copilot license tiers and Teams integration
- [Facilitator](facilitator.md) — Microsoft's built-in AI agent for meeting rooms

## References

- [Custom Engine Agents for M365 overview](https://learn.microsoft.com/en-us/microsoft-365-copilot/extensibility/overview-custom-engine-agent)
- [Build Custom Engine Agents in AI Foundry](https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/build-custom-engine-agents-in-ai-foundry-for-microsoft-365-copilot/4449623)
- [Foundry Agent Service at Ignite 2025](https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/foundry-agent-service-at-ignite-2025-simple-to-build-powerful-to-deploy-trusted-/4469788)
