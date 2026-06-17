# Mathlib Analogist Report

## Mode
api-alignment

## Slug
tsconstruct209

## Iteration
209

## Question
Is the `sheafification ∘ PresheafOfModules.tensorObj` construction the Mathlib-aligned
shape for obtaining the line-bundle (invertible-sheaf) group law, or is
`tensorObj_restrict_iso`'s difficulty an ARTIFACT of this construction? Evaluate
whether a different, cheaper construction makes restriction-compatibility definitional or
trivial — (a) transition 1-cocycles in `𝒪_X^×`; (b) `Pic X = H¹(X, 𝒪_X^×)`;
(c) lift `Module.Invertible` / `CommRing.Pic` via affine-local structure. For the
cheapest, say whether `tensorObj_restrict_iso` is even needed and what must be built.

> **Tooling note:** tool outputs were heavily delayed/batched early in the session; the
> `archon-lean-lsp` MCP eventually responded and I verified the core `Pic` idiom (below).
> Mathlib citations are tagged **[LSP-verified]** (confirmed via `leansearch`/`loogle` this
> session), **[prover-verified]** (from the iter-208 prover's `informal/tensorObj_restrict_iso.md`),
> or **[name-level]** (asserted by directive / project files; not independently re-confirmed).
>
> **Idiom confirmed [LSP-verified, `Mathlib.RingTheory.PicardGroup`]:** `Module.Invertible R M`
> is a real typeclass (⊗-invertibility); `CommRing.Pic R` is a `def`; `instCommGroupPic :
> CommGroup (CommRing.Pic R)` makes the **group structure automatic**;
> `CommRing.Pic.mk (R) (M) [AddCommMonoid M] [Module R M] [Module.Invertible R M] : CommRing.Pic R`
> builds the group from the invertibility predicate; and `instSmallUnitsSkeletonModuleCat :
> Small (CategoryTheory.Skeleton (ModuleCat R))ˣ` confirms `Pic = Units (Skeleton (ModuleCat R))`
> exactly as the directive asserted.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Predicate: geometric `IsLocallyTrivial` vs. ⊗-invertibility (`Module.Invertible` [LSP-verified]) | ALIGN_WITH_MATHLIB | critical |
| 2. Group law: per-axiom existence-isos on subtype vs. `Units(Skeleton)` (`CommRing.Pic` [LSP-verified]) | ALIGN_WITH_MATHLIB | critical |
| 3. `tensorObj := sheafify ∘ presheaf-tensor` (the `⊗` object def) | PROCEED | informational |
| 4a. Route (a) `𝒪_X^×` transition cocycles | NEEDS_MATHLIB_GAP_FILL | informational |
| 4b. Route (b) `Pic = H¹(X, 𝒪_X^×)` | NEEDS_MATHLIB_GAP_FILL | informational |
| 4c. Route (c) `Module.Invertible`/`Pic`, *specialized* (no global gluing) | ALIGN_WITH_MATHLIB | critical |

**Direct answer to the design question:** `tensorObj_restrict_iso`'s difficulty is an
**ARTIFACT** — not of the `⊗` definition (that is the correct Mathlib shape), but of proving a
**geometric local-triviality** statement about a **globally-sheafified** `⊗`. The Mathlib `Pic`
idiom never proves such a statement; in the aligned formulation **`tensorObj_restrict_iso` is
not needed**, and the sibling sorry `exists_tensorObj_inverse` also dissolves.

## The one load-bearing observation

`tensorObj_restrict_iso` has **exactly one consumer**: `tensorObj_isLocallyTrivial`
(`TensorObjSubstrate.lean:423`), where it runs `(M⊗N)|_W ≅ M|_W ⊗ N|_W ≅ 𝒪_W⊗𝒪_W ≅ 𝒪_W`.
That local-triviality lemma is required only because the carrier
`OnProduct = { M : (pullback πC πT).Modules // IsLocallyTrivial M }`
(`RelPicFunctor.lean:222-231` confirms the iter-188 concretization) is the subtype cut out by
the **geometric** predicate `IsLocallyTrivial M ≡ ∀ x, ∃ affine U ∋ x, M.restrict U.ι ≅ 𝒪_U`.

Causal chain producing the 4-iter blocker:

```
geometric IsLocallyTrivial carrier
  ⇒ must prove tensorObj_isLocallyTrivial
  ⇒ must compare a GLOBAL sheafified ⊗ against a LOCAL restriction
  ⇒ tensorObj_restrict_iso
  ⇒ opaque PresheafOfModules.pullback left adjoint   (~200–300 LOC, 4 absent ingredients)
```

The **same** geometric predicate independently forces the other open sorry,
`exists_tensorObj_inverse` (construct the global dual `L⁻¹` and the contraction `L⊗L⁻¹≅𝒪`) —
the obligation that pushed iter-206 into the verified-absent `MonoidalClosed (PresheafOfModules R₀)`.

Mathlib's invertible-sheaf / `Pic` idiom defines a line object by **⊗-invertibility**
(`∃ N, M ⊗ N ≅ 𝒪`), for which closure-under-`⊗` is monoidal algebra and the inverse is carried
by the predicate. **Neither restriction nor locality nor internal-hom is ever invoked.**

## Must-fix-this-iter

Both ALIGN verdicts apply to **shipped** code (the iter-206 `§2` pivot at
`TensorObjSubstrate.lean:221-233` and the `OnProduct` carrier), so they are must-fix:

- **Decision 1 (predicate).** `LineBundlePullback.lean`'s `IsLocallyTrivial`/`OnProduct` is a
  *geometric* predicate; building the group law on it forces `tensorObj_restrict_iso`
  (`TensorObjSubstrate.lean:330-399`) **and** `exists_tensorObj_inverse` (`:438-442`). Mathlib's
  idiom is **⊗-invertibility** (`Module.Invertible`, `∃ N, M ⊗ N ≅ R`)
  **[LSP-verified — `Mathlib.RingTheory.PicardGroup`]**. Under ⊗-invertibility:
  `tensorObj_isLocallyTrivial` → free (monoidal algebra), `exists_tensorObj_inverse` →
  definitional, `tensorObj_restrict_iso` → **not needed**. Concrete cost of *not* aligning:
  the ~200–300 LOC / 4-ingredient `restrict_iso` build (`pushforwardNatTrans`/`pushforwardCongr`/
  presheaf `pushforwardPushforwardAdj` + strong-monoidal `restrictScalars`-along-a-ring-iso, all
  **[prover-verified absent]**) PLUS the `MonoidalClosed`-flavored dual.

- **Decision 2 (group-law shape).** The iter-206 "four existence-of-iso lemmas on the subtype"
  shape (`TensorObjSubstrate.lean:221-233`) should be Mathlib's
  `Pic = Units (Skeleton (ModuleCat R))` shape **[LSP-verified — `Mathlib.RingTheory.PicardGroup`:
  `CommRing.Pic`, `instCommGroupPic`, `instSmallUnitsSkeletonModuleCat`]**, where the
  group is the units of the **commutative monoid of ⊗-iso-classes** and every axiom (incl. the
  inverse) is inherited from the monoid's coherence isos. The iter-206 pivot correctly rejected
  the full `MonoidalCategory`+`MonoidalClosed` instance, but its corrective swapped one hard
  obligation set (`restrict_iso` + dual) in rather than removing it.

## Informational

- **Decision 3 — `⊗` object definition: PROCEED.** `tensorObj := sheafify ∘
  PresheafOfModules.Monoidal.tensorObj` (`:199-202`) is the correct Mathlib shape for `⊗` on
  `SheafOfModules`. The two already-landed helpers `tensorObjIsoOfIso` (`:252`) and
  `tensorObj_unit_iso` (`:266`) demonstrate the cheap, correct pattern —
  `sheafification.mapIso (presheaf-level iso)`, no `pullback`, no opaque adjoint. Keep all three.

- **Decision 4a — cocycles: NEEDS_MATHLIB_GAP_FILL, not cheaper.** Čech 1-cocycles in `𝒪_X^×` do
  make restriction-compat free, but require a large parallel build (cocycle-data type, choice of
  trivializing covers, "bundle ≅ cocycle mod coboundary", bridge to the iso-class carrier).
  Mathlib has **no `𝒪_X^×` cocycle infra**, and the project's `Cohomology/*` Čech machinery is
  `ModuleCat k`-valued (additive) — **no reuse** for the multiplicative `𝒪_X^×`.

- **Decision 4b — `H¹(X, 𝒪_X^×)`: NEEDS_MATHLIB_GAP_FILL, strictly more work.** Group structure
  is automatic, but needs the multiplicative units sheaf `𝒪_X^×` as a sheaf of abelian groups
  (fresh infra; the project's `HModule` is `ModuleCat k`-valued — **near-zero reuse**, honest
  read of the hint), there is no Mathlib `Scheme.Pic` as `H¹`, and connecting to the `OnProduct`
  carrier needs `H¹(X,𝒪_X^×) ≅ {invertible-sheaf iso classes}` — itself a tensor-of-line-bundles
  theorem, i.e. circular for *this* goal.

- **Decision 4c — `Module.Invertible`/`Pic`, specialized: ALIGN (the cheapest path).** Naive
  "glue affine Picard groups by descent" is itself heavy (and the directive notes the
  `PicardGroup.lean` TODO "connect to invertible sheaves" is unbuilt). The cheap specialization
  needs **no** global gluing and **no** `Skeleton`/`Localization.Monoidal` typeclass: take the
  ⊗-invertibility predicate + a `CommMonoid` on ⊗-iso-classes assembled directly from
  `tensorObj`'s coherence isos.

- **The carrier predicate is NOT frozen — and the project ALREADY intended ⊗-invertibility.**
  Verified this session: `archon-protected.yaml` freezes only `Genus`/`Jacobian`/`AbelJacobi`
  declarations; `IsLocallyTrivial` (`LineBundlePullback.lean:115`) and
  `OnProduct = { M : (Limits.pullback πC πT).Modules // IsLocallyTrivial M }` (`:130-131`) are
  **not** protected — a structural/prover agent may change them (the plan/review agents then
  update the blueprint `\lean{...}` pin for `OnProduct`). **Decisively**, the file's own iter-174
  note documents the intent: "the iter-175+ body will instantiate [`OnProduct`] as a structure
  pairing a `(pullback πC πT).Modules` carrier with an **`IsInvertible` witness** once that
  predicate is in Mathlib (or proven internally)" (`:50-58`), and `IsLocallyTrivial` is described
  as "the project-side **stand-in for the missing Mathlib `IsInvertible` predicate**" (`:93-98`,
  `:106`), citing `Module.Invertible R M` in `Mathlib.RingTheory.PicardGroup`. **So the
  recommendation is not a new divergence — it is reverting to the project's own documented design
  intent, supplying `IsInvertible` as the internal project-side definition the note anticipated.**
  No user escalation is required.

- **Bonus: the `preimage_subgroup` Setoid already presupposes ⊗-invertibility.** Its intended
  relation is `L ~ L' ↔ L ⊗ (L')⁻¹ ∈ π_T^* Pic(T)` (`LineBundlePullback.lean:42-43, 349-351`) —
  i.e. it already needs `⊗` and `(·)⁻¹` on the carrier. Defining the carrier by ⊗-invertibility
  makes the inverse available for free, so this Setoid (currently a placeholder) also becomes
  constructible without `exists_tensorObj_inverse`.

- **No route is mathematically free.** Every construction (incl. the full `Localization.Monoidal`
  + `W.IsMonoidal` route the iter-206 §2 comment sketches at `:323-328`) bottoms out in the same
  fact "sheafification/⊗ commutes with localization-to-an-open." The recommendation's value is
  moving that fact **off the group-law critical path**, not deleting it from mathematics.

## Recommended concrete next steps (cheapest path)

1. Add `IsInvertible (M : X.Modules) : Prop := ∃ N, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)`
   (the `Module.Invertible` analogue).
2. Build the 3 missing coherence isos of `tensorObj` — associator, left/right unitor, braiding —
   each `= sheafification.mapIso (PresheafOfModules.Monoidal.<coherence iso>)`, copying the
   `tensorObj_unit_iso` pattern (`:266-272`). ~15 LOC each; **no `pullback`, no missing instance.**
3. Assemble a `CommMonoid` on ⊗-iso-classes (op `tensorObj`, well-defined via `tensorObjIsoOfIso`);
   the group on invertible elements is its `Units`.
4. Redefine `OnProduct` as `{ M : (pullback πC πT).Modules // IsInvertible M }` (the iter-174
   documented intent) — **not user-frozen** (verified against `archon-protected.yaml`); the
   plan/review agents update the `OnProduct` blueprint `\lean{...}` pin. `IsLocallyTrivial` can be
   kept as a *separate* lemma/predicate and connected later by the off-critical-path equivalence
   `IsInvertible ⟺ IsLocallyTrivial` (only the geometric direction is nontrivial; not needed for
   the group law).
5. Re-point `RelPicFunctor.addCommGroup` (`:235-269`) at the `Units`-derived group — `restrict_iso`,
   `isLocallyTrivial`, `exists_inverse` all drop off the critical path.

## Persistent file
- `.archon/analogies/tsconstruct209.md` — full decision-by-decision rationale for future iters.

Overall verdict: the `⊗` definition is correctly Mathlib-shaped, but the line-bundle group law
is built on the wrong predicate (geometric local-triviality instead of Mathlib's ⊗-invertibility,
`Module.Invertible`), which is the sole cause of the 4-iter `tensorObj_restrict_iso` blocker;
adopting the `Module.Invertible` / `Units(Skeleton)` idiom — which reverts to the project's OWN
documented iter-174 intent and touches no user-frozen declaration — removes `restrict_iso` AND
`exists_tensorObj_inverse` from the critical path entirely.
