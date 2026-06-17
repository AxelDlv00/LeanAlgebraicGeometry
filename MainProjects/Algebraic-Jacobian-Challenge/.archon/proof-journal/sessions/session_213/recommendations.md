# Recommendations — for the iter-214 plan agent

## TL;DR

The associator is **assembled** and waiting on ONE residual,
`PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` (L419). The next TS lane is a
**dedicated stalk-infrastructure build** (port ingredients d.1 + d.2 to `PresheafOfModules`),
NOT another associator realization and NOT a substrate pivot. Before/with that prover dispatch,
run a blueprint-writer pass to make the residual a tracked obligation and realign the associator
prose to ROUTE (d).

## CRITICAL / HIGH (top of the queue)

1. **[must-fix, blueprint] Pin the new `WhiskerOfW` lemmas; the sole open obligation is invisible.**
   (lean-vs-blueprint-checker ts213, must-fix.) Dispatch a blueprint-writer on
   `Picard_TensorObjSubstrate.tex` to add lemma blocks for:
   - `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` (the **sole residual `sorry`**) —
     state it (arbitrary `F`, `g ∈ J.W` ⟹ `F ◁ g` locally injective), describe the ROUTE (d)
     stalkwise proof, and document the two Mathlib-absent ingredients (d.1 module-level J.W↔stalk
     bridge on `Opens X`; d.2 stalk-commutes-with-relative-tensor) as the residual. Mark it as the
     only remaining open obligation of `lem:tensorobj_assoc_iso`.
   - `W_whiskerLeft_of_W`, `W_whiskerRight_of_W` (closed) — note they replace
     `lem:flat_whisker_localizer` on the associator critical path.
   Source material already on disk: `informal/isLocallyInjective_whiskerLeft_of_W.md`,
   `analogies/ts-monoidal213.md`.

2. **[must-fix, .lean docstrings — next prover, NOT review] Stale docstrings misdescribe the file.**
   (lean-auditor ts213, 4 must-fix.) Whoever next edits the TS file must refresh:
   - `tensorObj_assoc_iso` docstring (L622–658): rewrite to ROUTE (d); delete the flatness-feeder /
     carrier-friction "open obstacle" paragraph (both resolved) and the iter-212 status line.
   - `tensorObj` (L498) and `tensorObj_functoriality` (L512): drop the "the body is a typed `sorry`"
     claims — both have real bodies.
   - File module docstring (L37–46): drop "iter-202 scaffold, all bodies sorry."
   These are doc-only and can ride along with the d.1/d.2 prover dispatch; they are not blocking
   but they actively misinform.

3. **[major, blueprint] Decide the associator's intended generality, then realign the prose.**
   The Lean proves the **arbitrary-module** version (ROUTE d); the `IsLocallyTrivial` hyps `hM hN hP`
   are dead. Either (a) keep the hyps (signature-pin discipline) and have the blueprint say so
   explicitly, or (b) slim the signature to drop them (the decl is unprotected, so this is allowed).
   The blueprint-writer pass in (1) should reflect whichever the plan agent chooses. Recommend (a)
   for now (downstream `tensorObjIsoclassCommMonoid` consumes it on the locally-trivial carrier; a
   stable signature is cheaper than a re-pin).

## MEDIUM

4. **[major, blueprint] `lem:tensorobj_lift_onproduct` carrier predicate is wrong.** Prose claims
   `LineBundle.OnProduct` is the `IsInvertible` subtype; the Lean type is the `IsLocallyTrivial`
   subtype (from `LineBundlePullback.lean`) and the body uses only `tensorObj_isLocallyTrivial`.
   The `\uses{def:scheme_modules_isinvertible, lem:tensorobj_isoclass_commgroup}` are incorrect for
   this decl. A `% NOTE` is in place (this iter); the writer pass should fix the prose + `\uses`.

5. **[major, blueprint/Lean gap] `tensorObjIsoclassCommMonoid` is pinned but unscaffolded.** No Lean
   declaration exists. It is consumed by `thm:rel_pic_addcommgroup_via_tensorobj`. Once the residual
   lands (associator becomes axiom-clean), this is the next critical-path target — scaffold + prove.

## Blocked — do NOT re-assign as-is

- **`isLocallyInjective_whiskerLeft_of_W`** as a *one-shot proof target on present Mathlib*: blocked.
  Its proof requires the d.1 + d.2 infrastructure port. Assign it ONLY as part of a dedicated
  infra-build lane that first ports:
  - (d.1) `J.W (toPresheaf f) ↔ ∀ x, IsIso ((stalkFunctor x).map (toPresheaf f))` for module
    presheaves on `Opens X` (bridge `CategoryTheory.Presheaf.IsLocallyInjective/Surjective` to the
    `TopCat.Presheaf` stalk lemmas; abstractly `IsConservativeFamilyOfPoints.W_iff` +
    `TopCat.hasEnoughPoints`).
  - (d.2) `(A ⊗ᵖ B)_x ≅ A_x ⊗_{R_x} B_x` (stalk = filtered colimit; `tensorLeft`/`tensorRight`
    preserve filtered colimits; colimit-of-tensors over the colimit ring).
  Estimated ~200–400 LOC. Do NOT retry the pure-section / flat route on this lemma — attempt 2 this
  iter confirmed the Tor₁ obstruction makes it a dead end without flatness.

- **The substrate design / a 5th associator realization:** do NOT pivot. Four realizations are now
  mapped (1 monoidal-closed wall, 2 local-trivialization renamed-wall, 3 IsMonoidal-packaged-wall,
  the flat-exactness sectionwise-false route, route (c) section-level Tor₁ dead end). ROUTE (d) is
  sound and the associator is built around it. The remaining work is a finite, feasibility-confirmed
  infra port, not a route question. (The planner's pre-committed "escalate if route (c) fails"
  reversal does NOT bind here: route (c)'s section variant did fail, but route (d) — the sibling
  analogist realization — succeeded in assembling the associator, leaving only the d.1/d.2 port.)

## Process note

- The prover diverged from the dispatched route (c) to route (d). This was a *good* divergence —
  route (d) is the cleaner sibling realization, also vetted in `analogies/ts-monoidal213.md`, and the
  prover proved route (c)'s section variant is a dead end on the way. No corrective needed; just be
  aware the live route is (d) when reading the (now `% NOTE`-flagged) route-(c) blueprint prose.

## Reusable proof patterns discovered

- **Whisker-preserves-`J.W` flatness-free:** to show `F ◁ g ∈ J.W`, prove local *bijectivity* (not
  injectivity alone) — surjectivity is free (`isLocallySurjective_whiskerLeft`), and bijectivity is
  stalkwise-iso-stable under `id ⊗ −`. Avoids the flatness requirement entirely.
- **`rfl`-defeq carrier bridge:** `letI inst : C (Sheaf.val X.ringCatSheaf) := inferInstanceAs (C (X.presheaf ⋙ forget₂ CommRingCat RingCat))` transports a typeclass instance across the `rfl` carrier equality, dissolving the iter-212 `synthInstance`/heartbeat wall.
- **Braiding-conjugate whisker:** `g ▷ F = β_{M,F}.hom ≫ (F ◁ g) ≫ β_{N,F}.inv`, then
  `(J.W).cancel_left_of_respectsIso` / `cancel_right_of_respectsIso` to reduce a right-whisker
  property to the left-whisker one.
