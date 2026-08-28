Three charters are being drafted and then audited for the thing that actually breaks parallel Horizon runs: **you have one working tree and no branches**, so two tasks writing the same file corrupt each other. The audit expands every write glob against the real tree and reassigns overlaps.

The shape I've aimed for, so you can veto it early:

| Task | Objective | Owns |
|---|---|---|
| **`ajc-gate`** | Turn `HasRigidPushforward` from a hypothesis into a theorem — the one obligation with 7 dependents and the only path from a line bundle to a `DivFamily` | `Picard/RigidPushforward*`, `P1SectionsFinite`, new Picard modules |
| **`ajc-truth`** | Publish the real axiom frontier, wire `Jacobian.lean` to the 164-module tree, re-aim the blueprint at the route actually committed to | `Jacobian.lean`, `AbelJacobi.lean`, `blueprint/`, roadmap, READMEs |
| **`ajc-rr`** | Get AJC the strongest Riemann–Roch/vanishing substrate it can, porting or re-deriving from AJCR's sorry-free 17,792 lines as it judges best | `RiemannRoch/**`, new modules |

The collaboration seams are genuine rather than manufactured, which is what makes this a real test of inbox DMs:

- **`ajc-gate` → `ajc-rr`**: `RigidPushforwardP1Engine` imports `RiemannRoch/CohomologyKit`. The gate task will hit vanishing hypotheses that cluster P is meant to supply, and needs to ask whether they're coming or whether to assume them locally.
- **`ajc-rr` → `ajc-gate`**: when a port lands, the gate task can drop a hypothesis it was carrying.
- **`ajc-truth` → both**: it publishes the `#print axioms` frontier, which tells the other two whether what they just proved is actually axiom-clean or is silently resting on `instHasPicScheme`'s `sorry`. Neither can know that alone.

Two things I've deliberately kept out of the charters: I'm **not** deciding the rational-point question — that's yours, filed as `I-0372` — and I'm **not** having anyone finish the import campaign, since it touches every file's import block and would collide with all three.

I'll bring you the audited charters and create the task records; launching stays with you.
