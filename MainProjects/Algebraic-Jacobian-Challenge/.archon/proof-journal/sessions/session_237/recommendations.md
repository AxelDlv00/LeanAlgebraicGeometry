# Recommendations for the next plan iteration (post iter-237)

## TOP PRIORITY — the critical path is UNBLOCKED; pivot the prover to the group law

`tensorObj_assoc_iso` is now sorry-free + axiom-clean (verified) and `thm:pic_commgroup` is unblocked for
the first time in ~20 iters. The next near-term objective is the **by-hand group law**:
- `AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse` (TensorObjSubstrate.lean **L695**)
- `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj` (TensorObjSubstrate.lean **L760**)

These are the carrier-pivot deferred-bridge lane. Per the carrier pivot (memory `ts232-carrier-pivot`,
`commring-pic-is-skeleton-route`), the inverse is the membership WITNESS of tensor-invertibility — the
associator was the gate. The plan agent should scope this lane carefully: the auditor (L68–69) confirms both
are load-bearing sorries with honest body comments documenting the remaining C/A bridges. Decide whether the
carrier-pivot witness route closes them directly now that the associator is available, before dispatching.

## CRITICAL (blueprint structure) — must-fix-this-iter for the plan agent

1. **Malformed `\uses{}` with `\leanok` inside braces** — `Picard_TensorObjSubstrate.tex`, proof block of
   `lem:islocallyinjective_whiskerleft_via_stalk` (~L2227–2229). `sync_leanok` inserted `\leanok` between two
   lines of a multi-line `\uses{}`, breaking the parse (doctor + both vestigial-checker must-fixes). **Fix:**
   collapse the `\uses{...}` onto a single logical line and ensure `\leanok` sits AFTER the closing `}`. I did
   NOT edit this (review agent does not touch `\leanok`); the plan agent owns `\uses{}` prose and can reformat
   so the next `sync_leanok` places `\leanok` correctly. Also drop `lem:stalk_tensor_commutation_naturality_right`
   from that `\uses{}` (it has no backing decl — see #2).

## HIGH — blueprint `\lean{}` pin hygiene (plan-agent: add/repoint pins)

2. **Dangling pin `stalkTensorIso_naturality_right`** (`Picard_TensorObjSubstrate.tex`,
   `lem:stalk_tensor_commutation_naturality_right`). The B-naturality was *inlined* into the whiskering lemma;
   no standalone decl exists. I added a `% NOTE:`. Plan agent: either fold this block into the whiskering
   lemma's prose and drop the `\lean{}` pin, or keep it as an unformalized auxiliary without a pin.
3. **Dangling pin `pushforward_spec_tilde_iso`** (`Cohomology_FlatBaseChange.tex`). Only the conditional
   `pushforward_spec_tilde_iso_of_isLocalizedModule` was built. I added a `% NOTE:`. Plan agent: add `\lean{}`
   blocks for the 3 new route-iii helpers (`IsLocalizedModule.powers_restrictScalars`,
   `fromTildeΓ_app_isIso_of_isLocalizedModule`, `pushforward_spec_tilde_iso_of_isLocalizedModule`) and decide
   whether to repoint the unconditional pin.
4. **Missing pins in `Picard_TensorObjSubstrate.tex`** (vestigial-checker major): `lem:stalk_linear_map` has
   NO `\lean{}` for the `stalkLinearMap` quartet (`stalkLinearMap`, `_germ`, `_bijective_of_isIso`,
   `stalkLinearEquivOfIsIso`); the converse stalk-bridges `injective_stalk_of_isLocallyInjective` /
   `isLocallyInjective_of_injective_stalk` are unpinned; `lem:W_implies_stalkwise_iso` pins only the forward
   direction; `W_whiskerLeft_of_W` / `W_whiskerRight_of_W` are formalized but `lem:whisker_of_W` still carries
   a "must not be formalized" annotation. Reconcile these.

## HIGH — stale .lean docstrings (next prover or a `refactor` subagent — review agent cannot edit .lean)

5. The auditor flagged 5 MAJOR stale docstrings that **actively mis-describe the now-current proof**:
   - `TensorObjSubstrate.lean` L43 — STATUS block still lists `isLocallyInjective_whiskerLeft_of_W` as a
     remaining sorry residual (it is closed).
   - `TensorObjSubstrate.lean` L305 — `tensorObj_assoc_iso` docstring says "sorry-transitive only through the
     route-(e) residual" (no longer true).
   - `TensorObjSubstrate.lean` L309 — step descriptions say "(P flat)/(M flat)" via `W_whiskerRight_of_flat`,
     but the proof uses `W_whiskerRight_of_W`/`W_whiskerLeft_of_W` with **no flatness** — directly contradicts
     the code.
   - `TensorObjSubstrate.lean` L317–340 — the whole "flatness residual" block is now obsolete noise.
   - `Vestigial.lean` L16 — module docstring still says "one open sorry `isLocallyInjective_whiskerLeft_of_W`".
   These are comment-only edits; schedule a small `refactor`/prover docstring-cleanup pass (do not let them
   mislead the next prover into thinking the associator still needs flatness).

## FlatBaseChange lane — STUCK re-fires; do NOT re-dispatch the same prover round

6. The iter-237 hard sorry-closure commitment (`affineBaseChange_pushforward_iso`) was **not met** — it is
   gated behind the unconditional `pushforward_spec_tilde_iso`, which is blocked on the `hloc` carrier wall.
   Per the iter-237 plan's own recorded reversing signal, **STUCK re-fires**. Do NOT re-assign a verbatim
   prover round. Recommended correctives (pick one, don't stack helpers):
   - **mathlib-analogist consult** on identifying `IsLocalizedModule` on the structure-sheaf sections over a
     basic open `D(a)` for a pushforward of a tilde-module (the `hloc` obligation) — element-free `D(a)`-level
     transport mirroring `gammaPushforwardIso`; OR
   - deprioritize the affine sub-lane and re-route the engine seed to a different ungated A.2.c-engine brick.
   The route-iii skeleton (3 axiom-clean decls) is genuine recovery and should NOT be discarded; only the
   `hloc` *tactic* needs rethinking.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)
- **+/0 carrier-duality distribution:** distribute `map_add`/`map_zero` via `have … := map_add _ _ _` TERMS
  (defeq-coerced), `erw [map_zero]` for zero; never `rw`/`simp [map_add]` on the `AddCommGrpCat`/`ConcreteCategory`
  stalk hom — its `+`/`0` carrier differs syntactically from the `LinearEquiv` legs'.
- **d.1-bridge for the topological site:** `J.W g → stalkwise iso` via the NEW presheaf-level
  `injective_stalk_of_isLocallyInjective` (germ_eq + equalizer-sieve) + Mathlib's surjective half +
  `W_iff_isLocallyBijective` + `ConcreteCategory.isIso_iff_bijective`.
- **Two-localization equiv:** when `IsLocalizedModule.iso`/`.linearEquiv`/`.trans` fail instance synthesis on
  one factor, elaborate each `iso` in its own `set … with` so each resolves independently, then `.trans`.
