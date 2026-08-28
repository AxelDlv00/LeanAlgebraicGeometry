Everything is committed through the workspace ledger (the `??` is the normal out-of-tree-ledger view), and the final build is green. The session's objective slice is complete.

## Summary

Landed **brick 3 of the separatedness ledger** (`Over.prPullback_injective` — Kleiman 2.5(1)'s projection step, the gate item from I-0140): pullback of Čech Picard classes along `pr : (C ⊗ T).left ⟶ T.left` is injective, proved **for arbitrary test objects `T`** (stronger than the design's "affine `T`"), axiom-clean (`propext, Classical.choice, Quot.sound`), kernel-green (8597 jobs), with a 12-node all-`\leanok` blueprint section and the (C1)-assembly plan pinned for the next session.

Two structural simplifications made this land in one session: the anticipated "restriction bridge" `(C⊗T)|_{pr⁻¹V} ≅ C ⊗ Spec Γ(V)` was avoided entirely (mathlib's qcqs `pushoutSection` square applies directly with the affine slot on the `T` side), and the feared "fiberwise cocycle-glue" turned out to be exactly **degree-1 Čech refinement injectivity**, now a reusable theorem with the powerful corollary `CechPic.mk_eq_one_iff` (triviality is detected on the representing cover — no refinement chasing).

## Progress
- Picard/RefinementInjectivity.lean: NEW (208 lines) — unit-section gluing/separation toolkit, `unitsRes_injective` (H¹(𝒰) ↪ H¹(𝒲)), `CechPic.mk_eq_one_iff`, `CechPic.mk_injective`; axiom-clean.
- Picard/Separatedness.lean: NEW (317 lines) — `Flat.of_field`, `Over.isIso_appLE_snd` (section bijection over affine opens of any `T`), `appLE_snd_injective` (all opens), `unitsAppLE_snd_bijective`, affine refinement of pointed covers, `Over.prPullback_injective`; axiom-clean.
- Picard/UniversalSections.lean: stale brick-3 TODO replaced by a pointer to the landed theorem.
- AlgebraicJacobian.lean: both new files wired into the aggregator; full `lake build` green, 8597 jobs.
- blueprint/src/chapters/PicardEtale.tex: new section "Separatedness I" — 12 nodes, complete proofs, all `\leanok`, `\source{kleiman-picard}` on the keystone; `horizon blueprint` parses with 0 dangling.
- informal/wave3-picard-design.md: §4.4 ledger-status block + item-5 assembly plan (dictionary `CechPic (Spec R) ≃* CommRing.Pic R`; mathlib v4.31 already has `CommRing.Pic`, so only the Čech↔module dictionary + descent-datum extraction remain ours).
- I-0140 body updated with the state change; task comment left; memory `etale-plus-lane-recipes` rewritten with the new recipes and corrected stale claims.

## Issues
- Discovery: brick 4 (`Descent/ModuleDescent.lean` + `Descent/InvertibleModule.lean`) was already landed by an earlier session — the memory's "exists nowhere" claim was stale; corrected.
- Workspace-wide leandag artifact (pre-existing, not from this session): proof-level `\uses` don't create DAG edges (only statement-level ones do), so the new nodes — like many old ones, e.g. `cor:curve_sections` — show as "isolated" despite resolving. Left the blueprint conventional rather than churning it; noted in memory.
- Pre-existing hygiene warnings only (`show`-linter in Pic.lean/RelPic.lean, Challenge.lean sorries) — untouched, no correctness impact.

## Why I stopped
The assigned task (full challenge rebuild) is far larger than one session; this session's slice — the I-0140 gate item, brick 3 — is fully complete, verified, blueprinted, and committed. The next unit of work (the `CechPic (Spec R) ≃* CommRing.Pic R` dictionary, ~1 full session, then the (C1) assembly, ~1 more) deserves fresh context rather than a rushed, half-landed keystone. No terminal status set; the task returns to the queue.

## Next
- Build `Picard/PicAffine.lean`: the dictionary `(Spec R).CechPic ≃* CommRing.Pic R` (plan in design §4.4 "Item 5 plan"; use `CommRing.Pic.mk_eq_iff`, basic-open trivializations, `CechPic.mk_eq_one_iff`).
- Then the (C1) assembly (`relPicAlgMap` injectivity along étale covers) — the delicate step is extracting the comodule-form `Module.DescentDatum` from the cocycle-level lift, not just the class equality.
- Then the Zariski-sheaf-on-affines corollary and Layer-2 `picEt` (file 12), per the 13→12 lane order.
