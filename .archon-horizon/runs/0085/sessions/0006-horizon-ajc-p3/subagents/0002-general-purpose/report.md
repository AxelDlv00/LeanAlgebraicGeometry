You are a fresh-context ADVERSARIAL auditor for prover lane ajc-p3. Your job is to REFUTE claims, not confirm them. Read-only: do NOT edit any file under AlgebraicJacobian/. You may create/delete scratch files under `scratch_p3_audit/`.

Project: /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge (Lean 4). Commit 9e9ef819cd just landed `AlgebraicJacobian/Curve/SeparablyClosedRationalPoint.lean` (9 declarations, sorry-free, rooted in AlgebraicJacobian.lean).

Context you need: a 2026-07-29 audit of this workspace sampled 101 representability claims and refuted 99 — 67 sorry-reachable, 17 VACUOUS, 12 proving something adjacent to the claim. Assume my file has a defect and find it.

AUDIT THESE SPECIFIC CLAIMS, each of which is asserted in the file's docstrings or in my report:

1. **"§4's bridge is what cluster J actually consumes."** The file claims `Scheme.hasRationalPoint_baseChangeField_separableClosure` supplies the section that campaign milestones J1/J4/P4(c)(d) and `Picard/PicEtSubcanonical.lean:82-89` assume. VERIFY OR REFUTE by reading what those sites actually need. In particular: do they need a rational point on `C_{k^s}` where `k^s = SeparableClosure k`, or do they need it at a *finite Galois subextension* `k'/k` (campaign G1 spreads J5's datum to finite Galois level)? If cluster J needs points at finite levels and my lemma only delivers at the full separable closure, my "this is the root they assume" claim is hypothesis-shifted. Read `informal/pic-representability-campaign.md` clusters J and G, and the PicEtSubcanonical passage.

2. **Non-vacuity of the bridge.** Its binders are `[SmoothOfRelativeDimension 1 C.hom]` + `[GeometricallyIntegral C.hom]` over an arbitrary field `k`. Is that pack INHABITED in this project — is there any `C` for which all binders hold? If the only inhabitant is a degenerate one, say so. Try to exhibit a witness (P^1 over Q, or whatever the project already has — search for existing curve witnesses).

3. **"Properness is not used."** The file says the `IsProper` binder is absent and only `GeometricallyIntegral` supplies nonemptiness. Check the bridge's actual signature and confirm no properness sneaks in via instance synthesis.

4. **"GeometricallyIrreducible has no base-change-stability instance in this project, so the bridge must bind GeometricallyIntegral."** I measured this by a failed `inferInstance`. A failed synthesis is not a mathematical absence (this workspace has a filed lesson about exactly that). Check whether the geometrically-irreducible version is in fact derivable — e.g. via `MorphismProperty.pullback_snd` with a stability lemma that exists but is not an instance, or whether `geometricallyIntegral_of_curve` makes the point moot for consumers of the challenge package.

5. **Is any of the 9 declarations a duplicate of something already in AJC's import closure?** I checked `IsSepClosed` was absent from AJC by grep. Verify properly: for each of the 9, #check whether an equivalent statement already resolves. Note especially `instInfiniteOfIsSepClosed` — does mathlib already have `Infinite` for a separably closed field, making my §1 instance a duplicate that could cause a diamond?

METHOD RULES, which this workspace enforces:
- Build before probing: `lake build AlgebraicJacobian.Curve.SeparablyClosedRationalPoint` and confirm oleans are fresh. `lean_multi_attempt`/LSP reports every snippet as succeeding when imports are stale.
- Verify cited declarations with `#check` in a real file compiled by `lake env lean`, not by grep — a name can exist in source and be outside a file's import closure.
- Use `"$HORIZON_BIN" search "<words>" --json` (spans both projects AND mathlib) rather than grep for existence questions. Note: bare queries return hits from SubProjects/ under identical names, so distinguish which library a hit is in.
- Report what you measured and how. For each of the 5 claims give a verdict: CONFIRMED / REFUTED / PARTLY (with the exact part that fails). Quote the failing goal or error.

Clean up your scratch files at the end.
