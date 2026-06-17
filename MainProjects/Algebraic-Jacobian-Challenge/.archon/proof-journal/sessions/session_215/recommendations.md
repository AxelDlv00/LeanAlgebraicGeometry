# Recommendations for the iter-216 plan agent

## 0. The decision that must be made this iter (HIGH)

The iter-213/214/215 lane carried a **pre-committed gate**: "close
`isLocallyInjective_whiskerLeft_of_W` (count must DECREASE) in iter-215, else
escalate the ⊗-substrate route to USER in iter-216." The gate was **NOT met** a
2nd time (count 4→4; ~6 net-flat window-iters on this substrate). The escalation
branch is therefore **live**. The plan agent must explicitly pick one and record
the `## Decision made`:

- **(A) Escalate to USER** — surface that the relative-Picard `AddCommGroup` arm
  has been net-flat ~6 iters and now rests on a Mathlib-absent presheaf-level
  pushforward adjunction (H1, ~100–150 LOC); ask whether to fund the multi-iter
  mathlib-build or re-scope/defer the positive-genus Picard arm. This honors the
  pre-commitment.
- **(B) Fund ONE bounded H1 mathlib-build** — the residual is now genuinely
  *bounded and named* (it shrank this iter from H1+H2 to H1 alone). A
  single, scoped mathlib-build lane on the presheaf-level `pushforwardPushforwardAdj`
  could close `tensorObj_restrict_iso`, which cascades to unblock the PRIMARY
  route for `isLocallyInjective_whiskerLeft_of_W` AND `exists_tensorObj_inverse`.

Either is defensible; the planner must not silently dispatch another helper round
without choosing. **A 3rd unmet gate with no decision = the avoidance pattern this
gate exists to prevent.** If (B), pre-commit a HARD one-iter gate: H1 compiles
axiom-clean or escalate.

## 1. Do NOT re-dispatch on the same routes (HIGH — known blocker)

- `isLocallyInjective_whiskerLeft_of_W`: do **not** re-assign on the locally-trivial
  PRIMARY route at its current general-site signature, nor on the stalkwise
  FALLBACK, without a structural change first. PRIMARY is not statable for a
  general-site presheaf `F` (needs a large re-signing to `Scheme.Modules`/`Opens X`
  AND still needs the open `tensorObj_restrict_iso`); FALLBACK needs the
  Mathlib-absent d.2 (varying-ring stalk-⊗, ~150–250 LOC). Confirmed again this
  iter via loogle/leansearch.
- The genuine unblock is upstream: **close `tensorObj_restrict_iso` via H1** (the
  presheaf-level pushforward adjunction). That is the single lever.

## 2. The bounded H1 path, if (B) is chosen (the concrete recipe)

From the prover's task result + KB:
1. **H1 (the real obstacle, ~100–150 LOC, mathlib-build mode)**: presheaf-level
   `pushforward β ≅ pullback φ` via `Adjunction.leftAdjointUniq`, needing a
   presheaf-level `pushforwardPushforwardAdj` (only the SHEAF version exists in
   Mathlib — re-confirmed absent via loogle) plus presheaf-level
   `pushforwardNatTrans` / `pushforwardCongr`.
2. **H2 packaging (~20 LOC, now that H2's core is done)**: add
   `restrictScalars_μ_isIso (e : R ≃+* S) (M₁ M₂ : ModuleCat S) :
   IsIso (Functor.LaxMonoidal.μ (ModuleCat.restrictScalars e.toRingHom) M₁ M₂)` —
   thin wrapper identifying `μ`'s underlying map with `restrictScalarsRingIsoTensorEquiv`
   via `ModuleCat.restrictScalars_μ_tmul` + `TensorProduct.ext`; then upgrade the
   file's `restrictScalarsLaxMonoidal` to `Monoidal` via
   `Functor.Monoidal.ofLaxMonoidal` (`IsIso ε` is easy; lift presheaf `IsIso μ` via
   `toPresheaf` reflecting isos).

## 3. Blueprint-writer dispatch needed (MEDIUM — Lean↔blueprint drift)

lean-vs-blueprint-checker ts215 found the chapter `Picard_TensorObjSubstrate.tex`
has drifted from the Lean in two ways (the review agent left `% NOTE:` flags at
both sites; a writer should land the prose):
1. **Pin `restrictScalarsRingIsoTensorEquiv`** — add a statement block with
   `\lean{restrictScalarsRingIsoTensorEquiv}` (suggested statement in the checker
   report §"Recommended chapter-side actions"), and rewrite Step 3 of
   `lem:tensorobj_restrict_iso` to say H2 is closed / only H1 remains.
2. **Align `lem:tensorobj_assoc_iso` proof sketch** — the blueprint claims the
   `LocalizedMonoidal` API route; the Lean is the hand-assembled three-step
   ROUTE (d) composite (via `W_whiskerRight_of_W`, `isIso_sheafification_map_of_W`,
   `mapIso` of the presheaf associator, `W_whiskerLeft_of_W`), already closed.
This is a HARD-GATE prerequisite if a prover is to be sent at this chapter's files
next iter (per the per-file dispatch gate). A scoped writer + fast-path re-review
clears it in-iter.

## 4. Lean docstring cleanup (LOW — lean-auditor ts215, 5 major, no soundness risk)

Several docstrings/status comments in `TensorObjSubstrate.lean` still call now-real
definitions "typed sorry / scaffold": `tensorObj` (L739), `tensorObj_functoriality`
(L755), `tensorObj_assoc_iso` (L866, says "iter-212 typed sorry" but body is a
complete proof), `tensorObjOnProduct` (L1132), and the module-level status block
(L38, "each of the 4 pinned declarations carries a sorry body" — false for 2 of 4).
A prover assigned to this file should refresh these in passing; not worth a
dedicated lane. Also: confirm `@[implicit_reducible]` at L1160 is a real registered
attribute (auditor flagged it as non-standard; harmless while the body is sorry).

## 5. Reusable proof pattern landed this iter (for future cross-ring work)

`restrictScalarsRingIsoTensorEquiv` recipe (full detail in PROJECT_STATUS KB,
iter-215 Proof Patterns entry): base change along a ring iso commutes with `⊗`.
**The trick**: build the inverse as an `AddHom` via `TensorProduct.liftAddHom`
(NOT an `S`-linear `TensorProduct.lift` into an `e.symm`-base-changed module —
that triggers unsatisfiable `SMulCommClass`/`CompatibleSMul` synthesis), then
promote to `R`-linear by `TensorProduct.induction_on`. Right-inverse via
`LinearMap.ext`+`induction_on` (composite is `R`-linear over the `S`-tensor, so
`TensorProduct.ext'` type-mismatches); left-inverse via `ext'`+`rfl`. Use `change`
(not `show`) for `compHom`-defeq scalar goals.

## 6. Status reminders

- `tensorObjIsoclassCommMonoid` (the group-law engine consumed by
  `addCommGroup_via_tensorObj`) is pinned in the blueprint but does not yet exist
  in Lean. It consumes only `Nonempty` of the associator/unitor/braiding isos
  (associator already assembled). It cannot be built until
  `isLocallyInjective_whiskerLeft_of_W` closes (the associator transitively rests
  on it). Track as the final-step dependency, not a near-term target.
