# Lean ↔ Blueprint Check Report

## Slug
iter184-codimone

## Iteration
184

## Files audited
- Lean: `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
- Blueprint: `blueprint/src/chapters/Albanese_CodimOneExtension.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacyLocus}` (chapter: `def:indeterminacy_locus`)
- **Lean target exists**: yes (line 146)
- **Signature matches**: yes — `Set X` complement of `f.domain`, matching prose
- **Proof follows sketch**: yes — `(f.domain : Set X)ᶜ` is a one-line definition; closedness companion `isClosed_indeterminacyLocus` (line 151) also present
- **notes**: `\leanok` on statement block correct; `isClosed_indeterminacyLocus` not `\lean{}`-pinned but correctly anticipated as a "separate lemma" option in the blueprint prose. No issues.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.CodimOneFree}` (chapter: `def:codim_one_indeterminacy`)
- **Lean target exists**: yes (line 180)
- **Signature matches**: yes — `∀ (x : X), Order.coheight x = 1 → x ∈ f.domain`, matching the blueprint's `Order.coheight η = 1` encoding
- **Proof follows sketch**: N/A (definition, no proof body)
- **notes**: Clean. `\leanok` correct.

### `\lean{AlgebraicGeometry.Scheme.localRing_dvr_of_codim_one}` (chapter: `lem:smooth_codim_one_dvr`)
- **Lean target exists**: yes (line 302)
- **Signature matches**: yes — `IsDiscreteValuationRing (X.left.presheaf.stalk z)` under `[Smooth X.hom]`, `[IsIntegral X.left]`, `Order.coheight z = 1`
- **Proof follows sketch**: **partial** — the public theorem's proof body is sorry-free (assembles DVR via `IsDiscreteValuationRing.TFAE` from the private helper). However, the private helper `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` (line 223) carries one `sorry` for the `IsRegularLocalRing` half. The blueprint's proof sketch says "by smoothness O_{X,x} is regular" (Hartshorne I.5.1) but does not mention that this step is a **Mathlib gap** or point to Stacks 00TT as the route.
- **notes**: See §Iter-184 directive questions below. The `\leanok` on the proof block of `lem:smooth_codim_one_dvr` may be technically correct for `sync_leanok` (the public theorem's direct body is sorry-free) but is mathematically misleading: the underlying content remains sorry'd in the private helper. **The Krull-dim half** (closed axiom-clean in iter-183/184 via `Scheme.ringKrullDim_stalk_eq_coheight`) is not mentioned anywhere in the blueprint.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_of_codimOneFree_of_smooth}` (chapter: `thm:codim_one_extension`)
- **Lean target exists**: yes (line 371)
- **Signature matches**: yes — `∃! (g : X.left ⟶ Y.left), g.toRationalMap = f` under smooth source, complete target, `CodimOneFree f`
- **Proof follows sketch**: N/A — body is `:= sorry`; blueprint has a full proof sketch (Steps 1 and 2); this is pre-existing iter-178+ deferred work
- **notes**: Pre-existing sorry, expected per file header status. See Red flags.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacy_pure_codim_one_into_grpScheme}` (chapter: `lem:milne_codim1_indeterminacy`)
- **Lean target exists**: yes (line 412)
- **Signature matches**: yes — disjunction `indeterminacyLocus f = ∅ ∨ ∀ x ∈ …, ∃ z, Order.coheight z = 1 ∧ x ∈ closure {z}`, matching blueprint's "empty or pure codim 1"
- **Proof follows sketch**: N/A — body is `:= sorry`; blueprint has a full four-sub-step proof sketch; pre-existing deferred work
- **notes**: Pre-existing sorry, expected. See Red flags.

---

## Iter-184 directive questions

### Q1 — Does the blueprint cite Stacks 00TT (or equivalent) for the `IsRegularLocalRing` half clearly enough for an iter-185+ writer?

**No.** The blueprint's proof block for `lem:smooth_codim_one_dvr` (tex lines 212–237) says:

> "By smoothness, O_{X,x} is regular for every closed point x (Hartshorne I.5.1)."

This is mathematically correct but gives no Lean-actionable route. Problems:

1. **Stacks 00TT is not cited** anywhere in the chapter — neither in the proof block, the "Lean encoding scope" paragraph, nor the Mathlib readiness audit. Stacks 00TT is the Jacobian-criterion result that formalises "smooth morphism of schemes ⟹ regular at every stalk"; it is the bridge an iter-185+ prover needs.

2. **The Mathlib readiness audit** (tex lines 694–696) actively misleads: it states "Mathlib's smoothness predicate `AlgebraicGeometry.Smooth` bundles the regular-local-rings hypothesis." At b80f227 this is false — the implication is a Mathlib gap, not a bundled instance. A writer following the blueprint would assume no work is needed and be surprised by the sorry.

3. **The `IsAlgClosed kbar` requirement** for the Jacobian criterion argument (smooth over an algebraically closed field ⟹ regular at every stalk) is not named as a hypothesis bearing on this step.

An iter-185+ writer cannot derive from the blueprint alone which Lean API to target, that it is a Mathlib gap, or what hypotheses are load-bearing. **This is a blueprint adequacy failure for the `IsRegularLocalRing` half.**

### Q2 — Does the chapter describe the `Smooth X.hom + IsAlgClosed kbar ⟹ IsRegularLocalRing (stalk z)` path?

**No.** The blueprint does not name this as the intended route. The relevant type-class pair `[Smooth X.hom]` + `[IsAlgClosed kbar]` appears in the Lean file's theorem signature but nowhere in the blueprint's prose as a logically-connected unit. The proof sketch just invokes "smoothness" informally.

### Q3 — Is the Krull-dim half documented in the blueprint?

**No.** The iter-183 result `Scheme.ringKrullDim_stalk_eq_coheight` (in `Albanese/CoheightBridge.lean`) that closes the `ringKrullDim (stalk z) = 1` half axiom-clean is completely absent from the blueprint. The blueprint proof block says "the local ring O_{X,η} is regular of Krull dimension 1" without noting that this Krull-dim equality (coheight ↔ Krull dim of stalk) required a new bridge lemma, or that it is now shipped. An iter-185+ writer looking at the blueprint would not know that the Krull-dim half is done and only the `IsRegularLocalRing` half remains.

---

## Red flags

### Placeholder / suspect bodies

- `extend_of_codimOneFree_of_smooth` (line 383): `:= sorry`. The blueprint (`thm:codim_one_extension`) claims a full proof in two steps (Step 1 = DVR + valuative criterion, Step 2 = local cohomology extension). Pre-existing; expected per iter-177 skeleton, gated on Mathlib gaps. Flagged per rules.

- `indeterminacy_pure_codim_one_into_grpScheme` (line 426): `:= sorry`. Blueprint (`lem:milne_codim1_indeterminacy`) has a four-sub-step proof sketch. Pre-existing; expected. Flagged per rules.

- `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` (line 254, inside private helper): `sorry` for the `IsRegularLocalRing` half. The helper is private, so `sync_leanok` may not detect it via the public theorem; the `\leanok` on `lem:smooth_codim_one_dvr`'s proof block is therefore potentially misleading even if technically correct by the tool's implementation.

### Stale blueprint claim

- `blueprint/src/chapters/Albanese_CodimOneExtension.tex`, Mathlib readiness audit (lines 694–696): "Mathlib's smoothness predicate `AlgebraicGeometry.Smooth` bundles the regular-local-rings hypothesis" — **false at b80f227**. This is an excuse-comment equivalent in the blueprint: it tells the prover "nothing to do here" when there is a sorry to close.

### Stale Lean encoding list

- `blueprint/src/chapters/Albanese_CodimOneExtension.tex`, §"Lean encoding" item 6 (line 678): lists `AlgebraicGeometry.Scheme.RationalMap.extend_iff_order_nonneg` as the 6th declaration. This name was retired in iter-179 (renamed to `mem_domain_iff_exists_partialMap_through_point`). The Lean encoding list is stale.

---

## Unreferenced declarations (informational)

- `isClosed_indeterminacyLocus` (line 151): anticipated but not `\lean{}`-pinned; legitimate helper, low priority.
- `mem_domain_iff_exists_partialMap_through_point` (line 492): no `\lean{}` pin. The `thm:weil_divisor_obstruction` pin was intentionally detached in iter-179 (the `% NOTE` comment at tex line 551–567 explains this). A promised "lightweight `\begin{lemma}` block `lem:mem_domain_partial_map_reshuffle`" (iter-180+ blueprint-writer task) has not yet been added. The Lean encoding list still carries the old name `extend_iff_order_nonneg`. This declaration should get its own named blueprint block.

---

## Blueprint adequacy for this file

- **Coverage**: 5/5 `\lean{...}`-pinned declarations are present in the Lean file and match the blueprint at the signature level. 1 unreferenced declaration (`mem_domain_iff_exists_partialMap_through_point`) is substantive and should have its own block (promised but not yet written). 1 helper (`isClosed_indeterminacyLocus`) is acceptable unreferenced.

- **Proof-sketch depth**: **under-specified** for `lem:smooth_codim_one_dvr`'s `IsRegularLocalRing` half. The blueprint gives the correct mathematical narrative (smoothness → regular → DVR) but:
  - Does not name Stacks 00TT (or the Jacobian criterion) as the Lean route.
  - Does not mark this as a Mathlib gap.
  - Actively misleads via the false Mathlib audit claim.
  - Does not name `Scheme.ringKrullDim_stalk_eq_coheight` as closing the Krull-dim half.
  Proof sketches for `thm:codim_one_extension` and `lem:milne_codim1_indeterminacy` are adequate for their respective sorry bodies (both are well-sketched; the sorries are gated on deeper Mathlib gaps that are correctly identified in the proof blocks).

- **Hint precision**: **loose** for `lem:smooth_codim_one_dvr`. The `\lean{...}` pin is correct, but the proof prose's Lean-facing paragraph says "prover re-exports `IsRegularLocalRing.isDiscreteValuationRing_of_dim_one`" — this suggests the smooth→regular step is a given and only the dim-1→DVR conversion needs work. The actual situation is the opposite: dim-1→DVR is Mathlib-shipped, smooth→regular is the gap.

- **Generality**: matches need.

- **Recommended chapter-side actions** (for a blueprint-writer dispatch):
  1. In the proof block of `lem:smooth_codim_one_dvr`, add a "Lean gap" paragraph after the "Lean encoding scope" note that:
     - Names Stacks 00TT as the reference for `[Smooth X.hom]` + `[IsAlgClosed kbar]` ⟹ `IsRegularLocalRing (X.left.presheaf.stalk z)`.
     - Explicitly marks this as a Mathlib gap at b80f227.
     - Notes `[IsAlgClosed kbar]` is the hypothesis load-bearing for the Jacobian criterion.
  2. In the same proof block, add a note that the Krull-dim half (`ringKrullDim (stalk z) = coheight z`) is now closed axiom-clean via `Scheme.ringKrullDim_stalk_eq_coheight` from `Albanese/CoheightBridge.lean` (iter-183/184 work), so only the `IsRegularLocalRing` half remains as iter-185+ work.
  3. Correct the Mathlib readiness audit bullet (line 694–696): change "bundles the regular-local-rings hypothesis" to "does NOT yet provide `Smooth X.hom → IsRegularLocalRing (stalk z)` at b80f227 (Stacks 00TT gap; iter-185+ work)".
  4. Add a lightweight `\begin{lemma}` block `lem:mem_domain_partial_map_reshuffle` with `\lean{AlgebraicGeometry.Scheme.RationalMap.mem_domain_iff_exists_partialMap_through_point}` and a one-paragraph proof (definitional reshuffle of `RationalMap.mem_domain`), and update item 6 of the Lean encoding list accordingly.

---

## Severity summary

- **must-fix-this-iter**: None that block all file work. The two public sorry-bodies (`extend_of_codimOneFree_of_smooth`, `indeterminacy_pure_codim_one_into_grpScheme`) are pre-existing and expected per the iter-177 skeleton; they are not new this iter. **However**, the false Mathlib audit claim ("`Smooth` bundles the regular-local-rings hypothesis") is a blueprint correctness error that will misdirect an iter-185+ prover attempting to close the `IsRegularLocalRing` sorry — classifying as **must-fix** for the blueprint-writer dispatch.

- **major**:
  - Stacks 00TT uncited in blueprint; `IsRegularLocalRing` gap not named as a Mathlib gap (blueprint adequacy failure for that sorry).
  - Krull-dim half (iter-184 axiom-clean close) undocumented in the blueprint.
  - `mem_domain_iff_exists_partialMap_through_point` missing its promised `\begin{lemma}` block; Lean encoding list carries stale name `extend_iff_order_nonneg`.

- **minor**:
  - `isClosed_indeterminacyLocus` unreferenced but acceptable as a helper.
  - `\leanok` on proof block of `lem:smooth_codim_one_dvr` may be technically correct for `sync_leanok` but is mathematically misleading given the private helper's sorry.

**Overall verdict**: The chapter is well-structured for the Milne-level definitions and both sorry-body theorems, but is blueprint-inadequate for the `IsRegularLocalRing` half of `lem:smooth_codim_one_dvr`: Stacks 00TT is absent, the Mathlib audit actively misleads, and the iter-184 Krull-dim closure is undocumented — a blueprint-writer dispatch is needed before iter-185+ prover work begins on that sorry.

5 declarations checked, 3 sorry-related red flags, 1 false blueprint claim, 1 stale Lean encoding list entry.
