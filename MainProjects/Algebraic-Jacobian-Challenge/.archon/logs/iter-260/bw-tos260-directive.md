# Blueprint-writer directive — `Picard_TensorObjSubstrate.tex` (iter-260)

## Chapter to edit
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — ONLY this chapter.

This consolidated chapter `% archon:covers` four Lean files
(`TensorObjSubstrate.lean`, `StalkTensor.lean`, `Vestigial.lean`, `DualInverse.lean`).
Its single review verdict gates prover dispatch to ALL of them. There is one **live
MUST-FIX** (below) that currently blocks both the D3′ lane and the DualInverse lane.

## PRIMARY task — fix the Sq2b must-fix (empirically disproven proof prose)

In the proof of `\lem:pullback_tensor_map_basechange`, the **Sq2b paragraph**
(around lines 3960–4020, the "monoidality of `pullbackComp` — the genuinely new
ingredient" block) contains a sentence that the Lean has **empirically disproven**.
There is an in-place `% NOTE (iter-259)` comment block (around lines 4001–4011)
documenting exactly what is wrong; read it.

The false claim is the sentence reading approximately:

> "… reduces the goal to the lax-μ composition coherence of
> `PresheafOfModules.pushforward` across `pushforwardComp` — a concrete, sectionwise
> identity, **exactly as the unit twin `unitToPushforwardObjUnit_comp` holds
> definitionally**. The only new bookkeeping relative to the unit twin is the
> two-argument `tensorHom`/δ_natural shuffle, which follows the same template as
> Mathlib's `CategoryTheory.Adjunction.isMonoidal_comp`."

### What is actually true (from the iter-259 prover + lean-vs-blueprint-checker-tos259):
- The **mate-calculus reduction IS proven** (the Lean lemma `pullbackComp_δ` is a
  complete ~90-line proof). The η→δ transpose route described earlier in the paragraph
  (transpose under `homEquiv.injective`, `conjugateEquiv_pullbackComp_inv`,
  `unit_conjugateEquiv`, `Adjunction.comp_unit_app`) is correct and was executed.
- The reduction isolates **one** genuine residual: the lax-μ composition coherence of
  `PresheafOfModules.pushforward` across `pushforwardComp` (the Lean lemma
  `pushforwardComp_lax_μ`). This residual is **NOT definitional, NOT rfl, and NOT "the
  same template" as the unit twin**. The prover tested `rfl`, `ext W x; rfl`,
  `ext W x; simp`, `dsimp [...]; rfl` — all fail.
- Mathematical reason: the unit twin `unitToPushforwardObjUnit_comp` is `rfl` only
  because the unit comparison η touches the counit ε alone; the μ-version is the full
  tensorator interchange. `pushforwardComp_lax_μ` is the genuine
  **"`pushforwardComp` is monoidal"** theorem: a ~150-LOC `ModuleCat` change-of-rings
  coherence. Sectionwise (`ext W x`) it exposes the base-change associativity coherence
  for the composite ring map vs the two-step composite, requiring
  `ModuleCat.restrictScalarsComp`, `ModuleCat.extendScalarsComp`, and
  `ModuleCat.homEquiv_extendScalarsComp`. It is currently an open typed `sorry`.

### Required rewrite:
1. Replace the false sentence with an honest statement that the mate-calculus reduction
   (the η→δ transpose argument) closes Sq2b **modulo one genuine residual**: the
   monoidality of `PresheafOfModules.pushforward` across `pushforwardComp` (the
   "`pushforwardComp` is monoidal" identity, the right-adjoint twin of the δ-coherence).
2. State plainly that this residual is **NOT definitional** and is a `ModuleCat`
   change-of-rings coherence (base-change associativity for the composite ring map),
   naming the Mathlib primitives `ModuleCat.restrictScalarsComp`,
   `ModuleCat.extendScalarsComp`, `ModuleCat.homEquiv_extendScalarsComp`.
3. Keep the correct surrounding content: the δ = `homEquiv⁻¹((η⊗η);μ)` transpose pivot,
   the `conjugateEquiv_pullbackComp_inv` step, the `isMonoidal_comp`-style two-argument
   `tensorHom`/δ_natural bookkeeping (this IS done correctly in `pullbackComp_δ` — only
   the claim that the *final μ-coherence* is the "same template" is false; the two-arg
   shuffle itself is genuine and correct).
4. **Delete** the `% NOTE (iter-259)` comment block once the prose is corrected (it is
   scaffolding for this fix). Do NOT leave the disproven sentence anywhere.

Do not add or remove `\leanok` / `\mathlibok` markers (the sync phase / review agent
own those). You may write prose, `\lean{...}` hints, and `% NOTE:` math annotations.

## SECONDARY task — confirm the dual `sliceDualTransport` / `dual_restrict_iso` sketch is
## adequate for a route-(1) consumer proof (it is about to be dispatched)

The DualInverse lane will close `\lem:dual_restrict_iso` (Lean
`dual_restrict_iso`) this iter via its leg-(A) atom `sliceDualTransport`, as a
**consumer one-liner of the now-closed shared root** `Scheme.Modules.overEquivalence`
/ `restrictOverIso` / `unitOverIso` (all axiom-clean as of iter-259). The relevant
prose is around lines 5633–5760 ("leg-(A) atom `sliceDualTransport`").

Verify (and minimally expand if under-specified) that this section makes clear:
- `sliceDualTransport` is the per-open localization to `V` of the shared-root
  equivalence `overEquivalence U` (its functor is `pushforward (phiOver U)`); the
  reduced `𝒪_Y(V)`-linear equivalence
  `(restr fV' M ⟶ restr fV' 𝟙_X) ≃ₗ (restr V (pushforward β M) ⟶ restr V 𝟙_Y)`
  is exactly that localization (the iter-258/259 probe confirmed this).
- The close consumes `restrictOverIso` / `unitOverIso` localized to `V`, plus the
  bridge from the open immersion `f` to `U := f.opensRange` (`f ≅ U.ι`).
- The LHS `Module 𝒪_Y(V)` structure must be supplied via `Module.compHom (β.app V)`
  (it is not auto-synthesized) — this can be a one-line `% NOTE:` if helpful.
Do NOT rewrite the mathematics of this section if it is already adequate; only add the
missing route-(1)-consumer framing if it is absent or still describes the route as
"gated / not yet available" (the shared root IS now green).

## Out of scope
- Do NOT touch any other chapter.
- Do NOT attempt to describe a *proof* of `pushforwardComp_lax_μ` itself beyond naming
  the Mathlib primitives and its character (the actual ~150-LOC build is a separate
  future lane).
- Do NOT edit `\uses{}` lists except to fix an outright broken target.

## References
- `references/summary.md` for `ModuleCat` change-of-rings (Stacks tilde / base change).
  You may dispatch a `reference-retriever` child if you need a precise source for the
  base-change-of-modules associativity statement (write-domain `references/**` is
  authorized).
