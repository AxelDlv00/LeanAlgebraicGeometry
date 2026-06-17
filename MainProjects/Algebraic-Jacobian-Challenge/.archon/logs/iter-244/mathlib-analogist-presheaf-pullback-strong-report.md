# Mathlib Analogist Report

## Mode
api-alignment

## Slug
presheaf-pullback-strong

## Iteration
244

## Question
Is the comparison morphism `δ` of `PresheafOfModules.pullback φ` an isomorphism (is
`PresheafOfModules.pullback` STRONG monoidal, not merely oplax) in pinned Mathlib — via an
existing `Functor.Monoidal`/`CoreMonoidal` instance, or via a short provable route from sectionwise
`ModuleCat.extendScalars.Monoidal` (`distribBaseChange`)? Can `pullbackTensorMap` be upgraded to an
iso for general `M,N` at bounded cost, and what is the precise Mathlib idiom/path?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Existing strong/CoreMonoidal instance for `PresheafOfModules.pullback` | NEEDS_MATHLIB_GAP_FILL | informational (gap is upstream) |
| Short provable route to presheaf δ iso from `extendScalars.Monoidal` | NEEDS_MATHLIB_GAP_FILL | high-stakes (kills the hoped-for cheap route) |
| Directive's reduction "pullbackTensorMap iso ⟺ presheaf δ iso" is the operative one | PROCEED (correct, but unlocks nothing cheap) | informational |

## Bottom line (high-stakes routing decision)
**NO.** There is no existing strong instance, and δ-iso is NOT a bounded-cost upgrade. The
"3-line Stacks proof of `IsInvertible.pullback`" is **not available** in pinned Mathlib, because its
load-bearing input `lemma-tensor-product-pullback` (= pullback is strong monoidal) is precisely the
standard-but-unformalized content. **Do not re-route Lane 1 to "prove `pullbackTensorMap` iso in a
few lemmas."**

## Key findings (all verified on disk in the pinned tree)

1. `PresheafOfModules.pullback φ := (pushforward φ).leftAdjoint` — abstract left adjoint for a
   *general* `F : C ⥤ D`, **no sectionwise/colimit/stalk formula exposed**, NOT sectionwise
   `extendScalars`. `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pullback.lean:44`.

2. **No** `(pullback φ).Monoidal`/`.CoreMonoidal` instance and **no** `IsIso (δ …)` lemma anywhere
   in `ModuleCat/**` (grep). Only the project's own oplax mate exists.

3. Presheaf tensor is **sectionwise** (`tensorObj.obj X = M₁.obj X ⊗ M₂.obj X`),
   `…/Presheaf/Monoidal.lean`.

4. **Decisive decomposition:** `pushforward φ = pushforward₀ F R ⋙ restrictScalars φ`
   (`…/Presheaf/Pushforward.lean:86-87`) ⟹ `pullback φ ≅ extendScalars φ ⋙ pullback₀`.
   `extendScalars` is **strong** (`distribBaseChange`), so **presheaf δ iso ⟺ `pullback₀` δ iso**,
   where `pullback₀ = (pushforward₀).leftAdjoint = Lan F.op` (inverse image). The scalar half is
   free; the *topological inverse-image* half is the whole question.

5. `pushforward₀OfCommRingCat` is **strong with μ = `Iso.refl`** (`…/PushforwardZeroMonoidal.lean:33`)
   — pure reindexing commutes strictly with sectionwise tensor. But strength of `pushforward₀`
   does **not** give strength of its left adjoint for free.

6. **No general categorical shortcut.** `Adjunction.leftAdjointOplaxMonoidal`
   (`CategoryTheory/Monoidal/Functor.lean:1009`) yields oplax only; the lone oplax→strong upgrade
   `Functor.Monoidal.ofOplaxMonoidal` (line 704) *requires* `[∀ X Y, IsIso (δ)]` as input. No
   monoidal Kan-extension API (`Functor/KanExtension/*` has zero `monoidal`); no ModuleCat
   filtered-colimit/tensor interchange lemma; **no stalk functor for presheaves of modules** (grep).

7. **No `SheafOfModules` monoidal category and no sheaf-level pullback monoidal** anywhere
   (`ModuleCat/Sheaf/**` grep empty) — confirming the project must operate at presheaf+sheafification
   level, exactly as `pullbackTensorMap` does.

## The math, and why it doesn't rescue the cost
`pullback₀(M⊗N)(d) = colim_{(F↓d)} M(c)⊗N(c)` vs `(colim M(c))⊗(colim N(c))`; the comparison is iso
iff `(F↓d)` is filtered/sifted. For general `F` it fails (no general instance, consistent with #2).
For the geometric `F = Opens.map f.base`, `(F↓V) = {U : f⁻¹U ⊆ V}` is up-directed, so the presheaf δ
*is* genuinely an iso for the scheme pullback — the directive's `⟺` is correct and the iso is real
geometric content. **But** running that filtered-colimit argument needs a concrete `Lan`/inverse-image
model of `pullback₀` with a pointwise colimit formula, which the abstract adjoint does not expose.
The alternative — `a_Y.map(δ)` iso via δ *locally bijective* (`J.W_of_isLocallyBijective`,
`…/Presheaf/Sheafify.lean:398`, which inverts local isos under sheafification) — is strictly weaker
than δ-iso and is the one bounded *handle*, but it needs δ's stalks/local sections, and Mathlib has
no presheaf-of-modules stalk functor. **Every route bottoms out at the same Mathlib-absent concrete
inverse-image-of-presheaves-of-modules model.**

## Informational
- Cost estimate for making `pullbackTensorMap` an iso: **HIGH / multi-hundred-LOC**, matching
  iter-242 Analogue 2 (`analogies/pullback-tensor.md`). Honest route = build the concrete
  strong-monoidal inverse-image pullback (extendScalars strong ✓ + `Lan` strong via the filtered
  argument) and transport to the abstract `pullback` via `Adjunction.leftAdjointUniq`.
- The iter-243 local-trivialization pivot should NOT be dismissed as a "detour": strong-monoidality
  is Mathlib-scale, so the two routes are comparable; the planner should weigh them on equal footing
  rather than assume δ-iso is the bounded win.
- The negative result from iter-242 still stands: "oplax ⇒ preserves invertibles" is false
  (`Γ(ℙ¹,𝒪(1))=0`), so there is no free preservation lemma; δ-iso is genuinely required and genuinely
  unformalized.

## Persistent file
- `analogies/presheaf-pullback-strong.md` — full decomposition, citations, and rationale for future iters.

Overall verdict: NEEDS_MATHLIB_GAP_FILL — no strong instance exists and δ-iso is Mathlib-scale (not a few-lemma upgrade); the cheap "3-line `IsInvertible.pullback`" route is not available, so do not descope the alternative routes on the assumption that it is.
