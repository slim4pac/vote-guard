 VoteGuard Smart Contract

**VoteGuard** is a secure, transparent, and tamper-proof voting smart contract built for the Stacks blockchain using Clarity.  
It enables decentralized governance by allowing participants to create proposals, cast votes, and tally results without relying on centralized authorities.

---

Features
- **Proposal Creation:** Create proposals with a title, description, and voting deadline.
- **Secure Voting:** Each participant can vote only once per proposal.
- **Multiple Voting Options:** Supports Yes, No, and Abstain voting choices.
- **Result Tallying:** Votes can only be counted after the voting period ends.
- **Read-Only Queries:** Retrieve proposal details, voting status, and results without altering the blockchain state.

---

 Project Structure

---

 How It Works
1. **Create a Proposal:** Any user can submit a new proposal by providing a description and end time.
2. **Cast a Vote:** Voters can choose between `yes`, `no`, or `abstain`.
3. **End of Voting:** Once the deadline passes, results can be tallied.
4. **Query Results:** Anyone can check the final counts without modifying the contract state.

---

 Deployment
To deploy the contract using Clarinet:

```bash
clarinet deploy
