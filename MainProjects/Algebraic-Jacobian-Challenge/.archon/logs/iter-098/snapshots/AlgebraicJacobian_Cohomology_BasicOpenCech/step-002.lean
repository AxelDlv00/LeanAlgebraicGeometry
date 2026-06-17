/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.MayerVietorisCover

/-!
# Basic-open cover wrappers and the substantive Čech acyclicity theorem

This file (iter-063 split, cohort 3) contains the `basicOpenCover` family
of definitions and identification lemmas (iter-054), the producer
`hasAffineCechAcyclicCover_of_basicOpen` (iter-055), the
`cechCohomology_subsingleton_of_cechCochain_exactAt` lemma, and the
substantive theorem `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
(iter-056 → iter-062). The latter currently carries two labelled substep
sorries plus the iter-062 `h_a_fun` scaffolding.

This is cohort 3 of the original `MayerVietoris.lean` split:
* `MayerVietorisCore.lean`: MV LES core + Mathlib gap-fill.
* `MayerVietorisCover.lean`: 2-affine cover MV + cover-totality bridges +
  `IsCechAcyclicCover` consumers + `HasAffineCechAcyclicCover` carrier.
* `BasicOpenCech.lean` (this file): basic-open cover wrappers + the
  substantive Čech acyclicity theorem.

See `blueprint/src/chapters/Cohomology_MayerVietoris.tex`.
-/

set_option autoImplicit false

universe u v

open CategoryTheory Limits TopologicalSpace AlgebraicGeometry

namespace AlgebraicGeometry.Scheme

/-- Iter-054: basic-open cover from a spanning subset of `Γ(C.left, U)`.

Given a subset `s ⊆ Γ(C.left, U)`, this constructs the family of basic opens
`s → Opens` mapping each `f ∈ s` to `C.left.basicOpen f`. When `s` spans the
unit ideal of `Γ(C.left, U)` and `U` is affine, this family covers `U`
(see `basicOpenCover_supr_of_span_eq_top`); each member is itself an affine
open (see `basicOpenCover_isAffineOpen`).

Iter-054 is a thin Mathlib-API wrapper (parameterised by the project's
`C : Over (Spec (.of k))` convention) so iter-055+ instantiation work for
`HasAffineCechAcyclicCover (toModuleKSheaf C)` can call the constructor +
supremum + affine-membership directly.

Mirrors the iter-047 foundational parameterised Čech infrastructure pattern:
package thin Mathlib wrappers as named project-local declarations so the
substantive multi-iteration work downstream focuses purely on content
(Koszul acyclicity + Čech-vs-derived comparison) rather than re-deriving
infrastructure at every call site. -/
noncomputable def basicOpenCover
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat}
    (s : Set Γ(C.left, U)) :
    s → TopologicalSpace.Opens C.left.toTopCat :=
  fun f => C.left.basicOpen (f : Γ(C.left, U))

/-- Iter-054: supremum equality for the basic-open cover from generators
spanning the unit ideal of an affine open.

Given `(hU : IsAffineOpen U)` and `(hs : Ideal.span s = ⊤)`, the basic-open
cover `basicOpenCover s` covers `U` exactly: `⨆ i, basicOpenCover s i = U`.
This is a thin wrapper around Mathlib's `IsAffineOpen.iSup_basicOpen_eq_self_iff`
(`Mathlib/AlgebraicGeometry/AffineScheme.lean` L898).

Used by iter-055+ when constructing the `HasAffineCechAcyclicCover (toModuleKSheaf C)`
instance: the existential's third conjunct `(⨆ i, 𝒰 i = U)` is exactly what
this theorem produces. -/
theorem basicOpenCover_supr_of_span_eq_top
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat} (hU : IsAffineOpen U)
    (s : Set Γ(C.left, U)) (hs : Ideal.span s = ⊤) :
    ⨆ i, basicOpenCover (C := C) (U := U) s i = U := by
  unfold basicOpenCover
  exact hU.iSup_basicOpen_eq_self_iff.mpr hs

/-- Iter-054: each member of the basic-open cover of an affine open is itself
affine.

Given `(hU : IsAffineOpen U)` and `(i : s)`, conclude `IsAffineOpen (basicOpenCover s i)`.
This is a thin wrapper around Mathlib's `IsAffineOpen.basicOpen`
(`Mathlib/AlgebraicGeometry/AffineScheme.lean` L589).

Used by iter-055+ when proving the Koszul acyclicity of the basic-open Čech
complex: each finite intersection of basic opens is itself basic (hence affine),
which is the inductive step for the Koszul-style alternating-sum argument. -/
theorem basicOpenCover_isAffineOpen
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat} (hU : IsAffineOpen U)
    (s : Set Γ(C.left, U)) (i : s) :
    IsAffineOpen (basicOpenCover (C := C) (U := U) s i) := by
  unfold basicOpenCover
  exact hU.basicOpen i.1

/-- Iter-055: producer for `HasAffineCechAcyclicCover` from existence of basic-open
Čech-acyclic cover.

Given that for every affine open `U` of `C.left` there exists a spanning subset
`s ⊆ Γ(C.left, U)` with `Ideal.span s = ⊤` such that the basic-open cover
`basicOpenCover s : s → Opens` carries both `IsCechAcyclicCover F (basicOpenCover s)`
and `HasCechToHModuleIso F (basicOpenCover s)`, conclude `HasAffineCechAcyclicCover F`.

Iter-055 specialises iter-053's existence-bundled cover form to the basic-open cover
shape constructed iter-054. Strategic value: factors out the existence-bundling step
from iter-056+ substantive work, so the iter-056+ Koszul acyclicity branch and the
iter-057+ Čech-vs-derived comparison branch can each prove specifically the basic-open
form (which the universal Koszul + comparison arguments naturally produce), and the
iter-055 producer then bundles their results into iter-053's carrier shape automatically.

Body: destructures the per-affine existence to obtain `(s, hs, hacy, hcomp)`, then
bundles them into iter-053's existential cover via iter-054's
`basicOpenCover_supr_of_span_eq_top` to produce the supremum hypothesis. -/
theorem hasAffineCechAcyclicCover_of_basicOpen
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {F : Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k)}
    [HasExt.{u} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
    (h : ∀ {U : TopologicalSpace.Opens C.left.toTopCat}, IsAffineOpen U →
        ∃ (s : Set Γ(C.left, U)) (_ : Ideal.span s = ⊤),
          IsCechAcyclicCover F (basicOpenCover s) ∧
          HasCechToHModuleIso F (basicOpenCover s)) :
    HasAffineCechAcyclicCover F where
  exists_cover {U} hU := by
    obtain ⟨s, hs, hacy, hcomp⟩ := h hU
    exact ⟨s, basicOpenCover s, basicOpenCover_supr_of_span_eq_top hU s hs, hacy, hcomp⟩

/-- Iter-055: curve specialisation of `hasAffineCechAcyclicCover_of_basicOpen` at
`F := toModuleKSheaf C`.

Mirrors the iter-039/042/043/048/049/050/051/052/053 `_curve` pattern: a thin
dot-notation wrapper that saves call sites in the curve setting (where `F` is the
structure sheaf) from re-typing `toModuleKSheaf C` whenever the iter-055 producer
is chained through. Used by the iter-057+ packaging step to instantiate
`HasAffineCechAcyclicCover (toModuleKSheaf C)` once iter-056+ supplies the
per-affine basic-open Čech-acyclic + comparison-iso evidence. -/
theorem hasAffineCechAcyclicCover_of_basicOpen_curve
    {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [HasExt.{u} (Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))]
    (h : ∀ {U : TopologicalSpace.Opens C.left.toTopCat}, IsAffineOpen U →
        ∃ (s : Set Γ(C.left, U)) (_ : Ideal.span s = ⊤),
          IsCechAcyclicCover (toModuleKSheaf C) (basicOpenCover s) ∧
          HasCechToHModuleIso (toModuleKSheaf C) (basicOpenCover s)) :
    HasAffineCechAcyclicCover (toModuleKSheaf C) :=
  hasAffineCechAcyclicCover_of_basicOpen h

/-- Iter-056: pairwise basic-open intersection identification.

Given a Set `s ⊆ Γ(C.left, U)` and indices `i j : s`, the intersection of the
two basic-open cover members `basicOpenCover s i` and `basicOpenCover s j`
equals the basic open of the product `i.1 * j.1`. Direct iteration of Mathlib's
`Scheme.basicOpen_mul`.

This is the foundational identification for iter-057+ Čech complex evaluation:
the Čech cochain at degree 1 indexes pairs `(i, j) : s × s` and assigns the
sheaf evaluated at `basicOpenCover s i ⊓ basicOpenCover s j`. Via this lemma,
that intersection is identified with `C.left.basicOpen (i.1 * j.1)`, which by
`IsAffineOpen.isLocalization_of_eq_basicOpen` (Mathlib) is the localization
`Localization.Away (i.1 * j.1)` of `Γ(C.left, U)`. The Koszul-style
alternating-sum exactness on these localizations follows from
`exact_of_localized_span` (Mathlib) under `Ideal.span s = ⊤`. -/
theorem basicOpenCover_inter_eq_basicOpen_mul
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat}
    (s : Set Γ(C.left, U)) (i j : s) :
    basicOpenCover (C := C) (U := U) s i ⊓ basicOpenCover (C := C) (U := U) s j =
      C.left.basicOpen ((i.1 : Γ(C.left, U)) * j.1) := by
  unfold basicOpenCover
  exact (Scheme.basicOpen_mul C.left _ _).symm

/-- Iter-056: pairwise basic-open intersection on an affine open is itself
affine.

Given `(hU : IsAffineOpen U)`, `(s : Set Γ(C.left, U))`, and indices `i j : s`,
the intersection `basicOpenCover s i ⊓ basicOpenCover s j` is itself affine.
Thin wrapper combining `basicOpenCover_inter_eq_basicOpen_mul` (rewriting the
intersection as a basic open of the product) with Mathlib's
`IsAffineOpen.basicOpen` (membership preservation under basic-open formation).

Generalises iter-054's `basicOpenCover_isAffineOpen` (single-index affine
membership) to pairwise intersections. Used by iter-057+ Čech evaluation: each
finite intersection of basic opens is itself affine, which is the inductive
step for the Koszul alternating-sum argument (Stacks 03F7 / Hartshorne III.4.5
/ Eisenbud Commutative Algebra §17 Koszul resolution). -/
theorem basicOpenCover_inter_isAffineOpen
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat} (hU : IsAffineOpen U)
    (s : Set Γ(C.left, U)) (i j : s) :
    IsAffineOpen (basicOpenCover (C := C) (U := U) s i ⊓
        basicOpenCover (C := C) (U := U) s j) := by
  unfold basicOpenCover
  rw [← Scheme.basicOpen_mul]
  exact hU.basicOpen _

/-- Iter-057: n-ary basic-open intersection identification (Finset.inf' form).

Given a non-empty `Finset t : Finset s`, the infimum (over `t`) of the basic-open
cover members `basicOpenCover s i` for `i ∈ t` equals the basic open of the
finite product `∏ i ∈ t, i.1` in `Γ(C.left, U)`. Generalises iter-056's binary
`basicOpenCover_inter_eq_basicOpen_mul` to arbitrary non-empty Finset indexing.

Body via `Finset.cons_induction`: the empty case is impossible by `t.Nonempty`
(closed via `Finset.not_nonempty_empty`); the cons case splits on whether the
residual `t` is empty or non-empty (via `Finset.eq_empty_or_nonempty`). In the
empty residual case, `simp [basicOpenCover]` closes via single-element reduction
of `Finset.inf'` and `Finset.prod`. In the non-empty residual case, decompose
via `Finset.inf'_cons hne` to expose `basicOpenCover s a ⊓ rest`, decompose
`Finset.prod_cons` to expose `a.1 * (∏ i ∈ t, i.1)`, apply the IH to identify
`rest = C.left.basicOpen (∏ i ∈ t, i.1)`, then `change ... ⊓ _ = _` followed by
`rw [← Scheme.basicOpen_mul]` consolidates the product form.

This is the foundational identification for iter-058+ Čech complex evaluation
at arbitrary degree `n`: the Čech cochain at degree `n` indexes `x : Fin (n+1) → s`
and assigns the sheaf evaluated at `⨅ i : Fin (n+1), basicOpenCover s (x i)`.
Via this lemma (instantiated at `t := (Finset.univ : Finset (Fin (n+1))).image x`,
or more directly via `Finset.univ.inf' Finset.univ_nonempty (basicOpenCover s ∘ x)`),
that intersection identifies with `C.left.basicOpen (∏ i : Fin (n+1), (x i).1)`,
which by `IsAffineOpen.isLocalization_of_eq_basicOpen` (Mathlib) is the
localization `Localization.Away (∏ i, (x i).1)` of `Γ(C.left, U)`. -/
theorem basicOpenCover_finset_inf'_eq_basicOpen_prod
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat}
    (s : Set Γ(C.left, U)) (t : Finset s) (h : t.Nonempty) :
    t.inf' h (basicOpenCover (C := C) (U := U) s) =
      C.left.basicOpen (∏ i ∈ t, (i.1 : Γ(C.left, U))) := by
  classical
  induction t using Finset.cons_induction with
  | empty => exact absurd h Finset.not_nonempty_empty
  | cons a t ha ih =>
    rcases t.eq_empty_or_nonempty with rfl | hne
    · simp [basicOpenCover]
    · rw [Finset.inf'_cons hne, Finset.prod_cons, ih hne]
      change C.left.basicOpen (a.1 : Γ(C.left, U)) ⊓ _ = _
      rw [← Scheme.basicOpen_mul]

/-- Iter-057: n-ary basic-open intersection on an affine open is itself affine.

Given `(hU : IsAffineOpen U)`, `(s : Set Γ(C.left, U))`, `(t : Finset s)`, and
`(h : t.Nonempty)`, the n-ary intersection `t.inf' h (basicOpenCover s)` is
itself affine. Term-mode body chains
`basicOpenCover_finset_inf'_eq_basicOpen_prod` (rewriting the n-ary intersection
as a basic open of the finite product) with Mathlib's `IsAffineOpen.basicOpen`
(membership preservation under basic-open formation).

Generalises iter-056's `basicOpenCover_inter_isAffineOpen` (pairwise affine
membership) to arbitrary non-empty Finset indexing. Used by iter-058+ Čech
evaluation: each finite intersection of basic opens of an affine is itself
affine, which is the inductive step for the Koszul alternating-sum argument
(Stacks 03F7 / Hartshorne III.4.5 / Eisenbud Commutative Algebra §17 Koszul
resolution).

**Body uses `▸` (Eq.mpr), NOT `rw`**: `rw` on the equation produced by Theorem
(1) fails because of motive-occurrence issues with the implicit `Subtype.val`
coercions on elements of `Finset s`; term-mode `▸` rewrite resolves these
directly without invoking the rewriter's pattern-matching. Plan-agent
`lean_run_code` probe (this pass) confirmed the term-mode form compiles
kernel-only while the tactic-mode `rw` form fails with "Did not find an
occurrence of the pattern" error. -/
theorem basicOpenCover_finset_inf'_isAffineOpen
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat} (hU : IsAffineOpen U)
    (s : Set Γ(C.left, U)) (t : Finset s) (h : t.Nonempty) :
    IsAffineOpen (t.inf' h (basicOpenCover (C := C) (U := U) s)) :=
  basicOpenCover_finset_inf'_eq_basicOpen_prod s t h ▸ hU.basicOpen _

/-- Iter-058: n-ary basic-open intersection is contained in `U`.

Given a non-empty `Finset t : Finset s`, the infimum (over `t`) of the basic-open
cover members `basicOpenCover s i` for `i ∈ t` is contained in `U`. Term-mode
body chains iter-057's `basicOpenCover_finset_inf'_eq_basicOpen_prod` (rewriting
the n-ary intersection as a single basic open of the finite product) with
Mathlib's `Scheme.basicOpen_le` (`X.basicOpen f ≤ U` for any `f ∈ Γ(X, U)`)
via Lean's `▸` (Eq.mpr) rewrite.

**No `IsAffineOpen` hypothesis required**: `basicOpen_le` holds for any open `U`
(the basic open of `f ∈ Γ(X, U)` is always a sub-open of `U`); compare iter-057's
`basicOpenCover_finset_inf'_isAffineOpen` which does need `(hU : IsAffineOpen U)`.

This is the inclusion morphism iter-059+ Čech-evaluation arguments need when
applying Mathlib's `IsAffineOpen.isLocalization_of_eq_basicOpen`:
```
(hU : IsAffineOpen U) (f : Γ(X, U)) {V : X.Opens} (i : V ⟶ U) :
  V = X.basicOpen f → IsLocalization.Away f Γ(X, V)
```
The morphism `i : V ⟶ U` argument (which is `homOfLE` of `V ≤ U`) is needed to
install the `Algebra Γ(X, U) Γ(X, V)` instance for the conclusion type, since
Mathlib's `algebra_section_section_basicOpen` instance only fires for the
syntactic form `Γ(X, X.basicOpen f)`, not for `V = t.inf' h (basicOpenCover s)`.
Iter-058's inclusion lemma supplies this `V ≤ U` proof so iter-059+ can call
`hU.isLocalization_of_eq_basicOpen f (homOfLE (basicOpenCover_finset_inf'_le ...))
(basicOpenCover_finset_inf'_eq_basicOpen_prod ...)` to land
`IsLocalization.Away (∏ i ∈ t, i.1) Γ(C.left, t.inf' h (basicOpenCover s))`
directly. -/
theorem basicOpenCover_finset_inf'_le
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat}
    (s : Set Γ(C.left, U)) (t : Finset s) (h : t.Nonempty) :
    t.inf' h (basicOpenCover (C := C) (U := U) s) ≤ U :=
  basicOpenCover_finset_inf'_eq_basicOpen_prod s t h ▸
    C.left.basicOpen_le _

/-- Iter-059: n-ary basic-open intersection is a localization.

Given an affine open `U`, a subset `s ⊆ Γ(C.left, U)`, and a non-empty `Finset t : Finset s`,
the structure sheaf evaluated on the n-ary intersection of basic-open cover members
`t.inf' h (basicOpenCover s)` is identified — as a localization away from the product
`∏ i ∈ t, i.1` of generators — with `Γ(C.left, U)`. The algebra structure on the conclusion
type is given explicitly by `(C.left.presheaf.map (homOfLE _).op).hom.toAlgebra`, threaded
through the conclusion `@IsLocalization.Away _ _ f Γ(X, V) _ algebra` form (matching
Mathlib's `IsAffineOpen.isLocalization_of_eq_basicOpen` signature exactly).

**Explicit `@`-algebra binding is essential.** Mathlib's default
`algebra_section_section_basicOpen` instance (`Mathlib/AlgebraicGeometry/Scheme.lean` L724)
fires only for the syntactic form `Γ(X, X.basicOpen f)`, *not* for arbitrary `V`
definitionally equal to `X.basicOpen f`. The iter-058 plan-agent probe-confirmed that
stating this theorem with *inferred* algebra fails with
`failed to synthesize instance of type class Algebra Γ(C.left, U) Γ(C.left, t.inf' h …)`.
Threading the algebra structure as part of the conclusion type — matching Mathlib's
signature exactly — sidesteps the synthesis attempt.

This is the **fourth and final** thin foundational scaffolding helper on the affine
basic-open identification side. The iter-060+ basic-open Koszul acyclicity argument
(per the iter-059 analogy report at `analogies/cech-koszul-precedent.md`, Branch A
substep 2) chains iter-057's equality + iter-058's inclusion + iter-059's localization
+ `IsLocalizedModule.map_exact` (`Mathlib/Algebra/Module/LocalizedModule/Exact.lean`)
to identify each Čech-cochain factor `F(⋂_k 𝒰(x k))` with the cover-of-`D(f)` Čech complex
on localised modules. -/
theorem basicOpenCover_finset_inf'_isLocalization
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat} (hU : IsAffineOpen U)
    (s : Set Γ(C.left, U)) (t : Finset s) (h : t.Nonempty) :
    @IsLocalization.Away _ _ (∏ i ∈ t, (i.1 : Γ(C.left, U)))
      Γ(C.left, t.inf' h (basicOpenCover (C := C) (U := U) s)) _
      ((C.left.presheaf.map (homOfLE
        (basicOpenCover_finset_inf'_le (C := C) (U := U) s t h)).op).hom.toAlgebra) :=
  hU.isLocalization_of_eq_basicOpen _
    (homOfLE (basicOpenCover_finset_inf'_le (C := C) (U := U) s t h))
    (basicOpenCover_finset_inf'_eq_basicOpen_prod (C := C) (U := U) s t h)

/-- Iter-066 helper: in `ModuleCat k`, a product projection induced by an
injection of index sets is a split epi.

Given an injection `f : β → α` and a family `M : α → ModuleCat k`, the natural
projection `∏ᶜ_a M a ⟶ ∏ᶜ_b M (f b)` defined as `Pi.lift (fun b => Pi.π M (f b))`
(which sends a tuple indexed by `α` to its `image f` components, reindexed by `β`)
admits a section in `ModuleCat k`. The section is the "extend by zero" map:
given a tuple indexed by `β`, fill in the components in `image f` (using the
unique preimage given by injectivity of `f`) and set the remaining components
to `0`.

This is the categorical fact underlying `h_π_split` in
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf`: the cochain-complex map
`π : K ⟶ K₀` is at each degree of this form (the `↑s₀ ↪ s` inclusion induces a
postcomposition map `(Fin (i+1) → ↑s₀) → (Fin (i+1) → s)` which is injective by
injectivity of the inclusion, hence the induced product projection on cochain
factors is split).

The helper is stated for a generic injection so it can be reused for both the
`s` substep (`h_π_split` proper) and the slice-cover variants. -/
noncomputable def splitEpi_pi_lift_of_injective {k : Type u} [Field k]
    {α β : Type u} (M : α → ModuleCat.{u} k)
    (f : β → α) (hf : Function.Injective f) :
    SplitEpi (Pi.lift (fun b : β => Pi.π M (f b))) where
  section_ := by
    classical
    refine Pi.lift (fun a => ?_)
    by_cases h : ∃ b, f b = a
    · exact h.choose_spec ▸ Pi.π (fun b => M (f b)) h.choose
    · exact 0
  id := by
    classical
    apply Pi.hom_ext
    intro b
    rw [Category.assoc, Pi.lift_π, Category.id_comp, Pi.lift_π]
    have h : ∃ b', f b' = f b := ⟨b, rfl⟩
    rw [dif_pos h]
    -- The transport `h.choose_spec ▸ Pi.π _ h.choose = Pi.π _ b`.
    -- By injectivity of `f`, `h.choose = b`, so the transport collapses.
    -- We use the helper lemma below.
    have key : ∀ {b b' : β} (heq : f b' = f b),
        heq ▸ (Pi.π (fun b'' => M (f b'')) b' :
            (∏ᶜ fun b'' => M (f b'')) ⟶ M (f b')) =
          (Pi.π (fun b'' => M (f b'')) b :
            (∏ᶜ fun b'' => M (f b'')) ⟶ M (f b)) := by
      intro b b' heq
      have hbb : b' = b := hf heq
      subst hbb
      rfl
    exact key h.choose_spec

/-- Iter-060 helper: bridge from `ExactAt n` on the Čech cochain complex to
`Subsingleton (cechCohomology n)`.

The chain is two steps: `HomologicalComplex.ExactAt.isZero_homology` packages an
`ExactAt n` hypothesis into `IsZero ((cechCochain ...).homology n)`, and
`ModuleCat.subsingleton_of_isZero` then upgrades `IsZero` on a `ModuleCat`
object to `Subsingleton` on its underlying carrier type.

This is the structural skeleton common to *every* `IsCechAcyclicCover` instance
proof: the actual mathematical content lives in establishing
`(cechCochain C F 𝒰).ExactAt n` for each `n > 0`. -/
theorem cechCohomology_subsingleton_of_cechCochain_exactAt
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {F : Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k)}
    {ι : Type u} {𝒰 : ι → TopologicalSpace.Opens C.left.toTopCat}
    {n : ℕ} (h : (cechCochain C F 𝒰).ExactAt n) :
    Subsingleton (cechCohomology C F 𝒰 n) :=
  ModuleCat.subsingleton_of_isZero h.isZero_homology

/-- Iter-087 (refactor): per-summand R-linear restriction-collapse. For nested
opens `V ≤ W ≤ U` in a scheme `C.left`, the chain of presheaf restrictions
`Γ(U) → Γ(W) → Γ(V)` collapses to the direct restriction `Γ(U) → Γ(V)`.

Used in the proof of R-linearity of the Čech differential
(`cechCofaceMap_pi_smul`): each per-summand restriction chain
`R = Γ(C.left, U) → Γ(C.left, V_{j∘δ_i}) → Γ(C.left, V_j)` collapses to the
direct map `R → Γ(C.left, V_j)`, matching the per-i R-action induced by the
restriction algebra structure on the cochain factor.

Extracted iter-087 from the inline `have R_restrict_R_linear` (iter-086) inside
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf`. The body is the
2-tactic proof verified by the iter-086 prover. -/
lemma presheafMap_restrict_collapse
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {V W U : TopologicalSpace.Opens C.left.toTopCat}
    (h_VW : V ≤ W) (h_VU : V ≤ U) (h_WU : W ≤ U)
    (r : C.left.presheaf.obj (Opposite.op U)) :
    (C.left.presheaf.map (homOfLE h_VW).op).hom
        ((C.left.presheaf.map (homOfLE h_WU).op).hom r) =
      (C.left.presheaf.map (homOfLE h_VU).op).hom r := by
  rw [← ConcreteCategory.comp_apply, ← C.left.presheaf.map_comp]
  congr 1

set_option maxHeartbeats 800000 in
/-- Iter-096 (refactor extraction): structural lemma — if each summand
`F i` is R-linear (with respect to the LinearEquivs `e₁`, `e₂`), then
so is `∑ i ∈ s, F i`. The summand family `F : ι' → (M ⟶ N)` is named
abstractly, so applying this lemma to the Čech alternating sum
`∑ i, (-1)^↑i • Pi.lift fun i_1 ↦ ...` only requires Miller-pattern
unification `F := fun i ↦ <literal summand>` — no HOU on the
nested-i body.

Body left as `sorry` for the iter-097 prover. Proof sketch:
induct on the finset `s` via `Finset.cons_induction`. Base case is
the empty sum = 0, which is trivially R-linear via the `ModuleCat`
zero morphism. Cons step: `F i + ∑ j ∈ s', F j` is R-linear because
R-linearity is preserved under addition (`ModuleCat.hom_add` plus
R-linearity of each summand).

**Refactor note (iter-096):** The directive also requested a companion
`cechCofaceMap_pi_smul_summand` that bakes the Čech summand literal
into its signature. That signature triggers a whnf timeout at the
`Pi.lift (fun x ↦ Pi.π (basicOpenCover ↑s₀ ∘ i_1) ((SimplexCategory.δ i)
.toOrderHom x))`-elaboration step, because Lean attempts to unify
`Fin ((ComplexShape.up ℕ).prev n + 1) → ↥s₀` with `Fin n → ↥s₀` through
the heavy `ComplexShape.prev` definition. We omit that helper in iter-096;
the abstract structural lemma below suffices to give the iter-097 prover a
HOU-friendly hook (instantiate `F := fun i ↦ <Čech summand>` and discharge
per-summand R-linearity inline). -/
theorem alternating_sum_pi_smul_aux
    {k : Type u} [Field k]
    {R : Type*} [Ring R]
    {ι₁ : Type u} {ι₂ : Type u} (Z₁ : ι₁ → ModuleCat.{u} k)
    (Z₂ : ι₂ → ModuleCat.{u} k)
    [_mZ1 : Module R ((∀ i, Z₁ i))] [_mZ2 : Module R ((∀ j, Z₂ j))]
    {ι' : Type*} (s : Finset ι')
    (F : ι' → ((∏ᶜ Z₁ : ModuleCat.{u} k) ⟶ (∏ᶜ Z₂ : ModuleCat.{u} k)))
    (e₁ : (∏ᶜ Z₁ : ModuleCat.{u} k) ≃ₗ[k] ∀ i, Z₁ i)
    (e₂ : (∏ᶜ Z₂ : ModuleCat.{u} k) ≃ₗ[k] ∀ j, Z₂ j)
    (hF : ∀ i ∈ s, ∀ (r : R) (y : ∀ i, Z₁ i),
      e₂ ((F i).hom (e₁.symm (r • y))) =
        r • e₂ ((F i).hom (e₁.symm y))) :
    ∀ (r : R) (y : ∀ i, Z₁ i),
      e₂ ((∑ i ∈ s, F i).hom (e₁.symm (r • y))) =
        r • e₂ ((∑ i ∈ s, F i).hom (e₁.symm y)) := by
  -- iter-097 Step 1: induct on `s` via `Finset.cons_induction`. Empty case
  -- collapses via `ModuleCat.hom_zero`; cons step distributes `Finset.sum_cons`
  -- + `ModuleCat.hom_add` + `LinearMap.add_apply` + `map_add` simultaneously
  -- on both sides via `simp only`, then applies `hF` for the head and `ih`
  -- for the tail, finishing with `smul_add`. HOU-free because `F` is a binder.
  revert hF
  induction s using Finset.cons_induction with
  | empty =>
    intro _hF r y
    simp [Finset.sum_empty, ModuleCat.hom_zero, LinearMap.zero_apply,
      map_zero, smul_zero]
  | cons i s' hi ih =>
    intro hF r y
    simp only [Finset.sum_cons, ModuleCat.hom_add, LinearMap.add_apply, map_add]
    rw [hF i (Finset.mem_cons_self i s')]
    rw [ih (fun j hj => hF j (Finset.mem_cons.mpr (Or.inr hj))) r y]
    rw [smul_add]

/-- Iter-098 refactor: sum-through-composition extension of
`alternating_sum_pi_smul_aux`. The existing lemma's single morphism
family `F : ι' → ((∏ᶜ Z₁) ⟶ (∏ᶜ Z₂))` cannot absorb an intermediate
`eqToHom` because instantiating `F := fun i ↦ G i ≫ eqToHom`
re-introduces a `Fin (...) → ↑s₀` vs `Fin (n + 1) → ↑s₀` unification
problem outside tactic state (the iter-097 Attempt 5 dead-end). This
parallel lemma splits the morphism into a family `G : ι' → ((∏ᶜ Z₁) ⟶
(∏ᶜ Z_int))` plus a single `E : (∏ᶜ Z_int) ⟶ (∏ᶜ Z₂)`, so the
`eqToHom` slot at the call site lands in `E` (an independent
elaboration slot) rather than inside the family.

Body left as `sorry` for the iter-099 prover. Proof sketch:
`rw [Preadditive.sum_comp s G E]` to convert
`(∑ G i) ≫ E` to `∑ (G i ≫ E)`, then `exact
alternating_sum_pi_smul_aux Z₁ Z₂ s (fun i ↦ G i ≫ E) e₁ e₂ hG r y`.
Both rewrites are HOU-free at the signature level because `G` is a
binder, not a literal with nested-`i` Pi.lift body. -/
theorem alternating_sum_pi_smul_aux_sum_comp
    {k : Type u} [Field k]
    {R : Type*} [Ring R]
    {ι₁ : Type u} {ι_int : Type u} {ι₂ : Type u}
    (Z₁ : ι₁ → ModuleCat.{u} k)
    (Z_int : ι_int → ModuleCat.{u} k)
    (Z₂ : ι₂ → ModuleCat.{u} k)
    [_mZ1 : Module R ((∀ i, Z₁ i))] [_mZ2 : Module R ((∀ j, Z₂ j))]
    {ι' : Type*} (s : Finset ι')
    (G : ι' → ((∏ᶜ Z₁ : ModuleCat.{u} k) ⟶ (∏ᶜ Z_int : ModuleCat.{u} k)))
    (E : (∏ᶜ Z_int : ModuleCat.{u} k) ⟶ (∏ᶜ Z₂ : ModuleCat.{u} k))
    (e₁ : (∏ᶜ Z₁ : ModuleCat.{u} k) ≃ₗ[k] ∀ i, Z₁ i)
    (e₂ : (∏ᶜ Z₂ : ModuleCat.{u} k) ≃ₗ[k] ∀ j, Z₂ j)
    (hG : ∀ i ∈ s, ∀ (r : R) (y : ∀ i, Z₁ i),
      e₂ ((G i ≫ E).hom (e₁.symm (r • y))) =
        r • e₂ ((G i ≫ E).hom (e₁.symm y))) :
    ∀ (r : R) (y : ∀ i, Z₁ i),
      e₂ (((∑ i ∈ s, G i) ≫ E).hom (e₁.symm (r • y))) =
        r • e₂ (((∑ i ∈ s, G i) ≫ E).hom (e₁.symm y)) := by
  -- iter-099 Step 1: distribute `Preadditive.sum_comp` (HOU-free since `G`
  -- and `E` are lemma binders, not literals), then apply
  -- `alternating_sum_pi_smul_aux` on the family `fun i ↦ G i ≫ E`.
  intro r y
  rw [Preadditive.sum_comp s G E]
  exact alternating_sum_pi_smul_aux Z₁ Z₂ s (fun i ↦ G i ≫ E) e₁ e₂ hG r y

set_option maxHeartbeats 1600000 in
/-- Iter-087 (refactor, CORRECTIVE): R-linearity of the Čech-cochain
differential at degree `(prev n, n)` in the product representation, specialized
to the project's Čech-cochain context (`basicOpenCover` of an affine `U` from a
spanning finset `s₀`).

**Statement specialization.** The previous iter-087 abstraction quantified
universally over `(Z₁, Z₂, e₁, e₂, scK₀_f, h_mod_pi₁, h_mod_pi₂, R)`, yielding
a mathematically false statement for arbitrary `scK₀_f`. This corrective
version fixes `R`, `K₀`, `scK₀`, `Z_i`, `e_i`, `h_mod_pi_i` from the
Čech-cochain context, so the conclusion is mathematically true: the Čech
differential is a finite alternating sum of presheaf restriction maps, each
R-linear (see `presheafMap_restrict_collapse`), hence the sum is R-linear
componentwise.

The body is `sorry`; the iter-088+ prover closes it. The duplicated `letI`
block (perI₁/h_mod_pi₁/perI₂/h_mod_pi₂) mirrors the inline let-block inside
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf` so the call site
`cechCofaceMap_pi_smul hU s₀ hn` produces a term that definitionally matches
the local `h_diff_pi_smul_f` shape used at the consumer (`f_R.map_smul'`). -/
theorem cechCofaceMap_pi_smul
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat} (hU : IsAffineOpen U)
    (s₀ : Finset Γ(C.left, U)) {n : ℕ} (hn : 0 < n) :
    let R := Γ(C.left, U)
    let K₀ := cechCochain C (toModuleKSheaf C)
      (basicOpenCover (C := C) (U := U) (↑s₀ : Set Γ(C.left, U)))
    let scK₀ := HomologicalComplex.sc K₀ n
    let Z₁ := fun (i : Fin ((ComplexShape.up ℕ).prev n + 1) → ↑s₀) =>
      ModuleCat.of k (C.left.presheaf.obj
        (Opposite.op (∏ᶜ fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a))))
    let Z₂ := fun (i : Fin (n + 1) → ↑s₀) =>
      ModuleCat.of k (C.left.presheaf.obj
        (Opposite.op (∏ᶜ fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a))))
    let e₁ := (ModuleCat.piIsoPi Z₁).toLinearEquiv
    let e₂ := (ModuleCat.piIsoPi Z₂).toLinearEquiv
    letI perI₁ : ∀ i, Module R (Z₁ i) := fun i => by
      apply RingHom.toModule
      refine (C.left.presheaf.map (homOfLE ?_).op).hom
      let a0 : Fin ((ComplexShape.up ℕ).prev n + 1) := ⟨0, by omega⟩
      have h1 : ∏ᶜ (fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a)) ≤
        basicOpenCover (C := C) (U := U) ↑s₀ (i a0) := (Pi.π _ a0).le
      have h2 : basicOpenCover (C := C) (U := U) ↑s₀ (i a0) ≤ U :=
        basicOpen_le C.left (i a0 : Γ(C.left, U))
      exact h1.trans h2
    letI h_mod_pi₁ : Module R (∀ i, Z₁ i) := Pi.module _ _ _
    letI perI₂ : ∀ i, Module R (Z₂ i) := fun i => by
      apply RingHom.toModule
      refine (C.left.presheaf.map (homOfLE ?_).op).hom
      let a0 : Fin (n + 1) := ⟨0, by omega⟩
      have h1 : ∏ᶜ (fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a)) ≤
        basicOpenCover (C := C) (U := U) ↑s₀ (i a0) := (Pi.π _ a0).le
      have h2 : basicOpenCover (C := C) (U := U) ↑s₀ (i a0) ≤ U :=
        basicOpen_le C.left (i a0 : Γ(C.left, U))
      exact h1.trans h2
    letI h_mod_pi₂ : Module R (∀ i, Z₂ i) := Pi.module _ _ _
    ∀ (r : R) (y : ∀ i, Z₁ i),
      e₂ (⇑(ConcreteCategory.hom scK₀.f) (e₁.symm (r • y))) =
        r • e₂ (⇑(ConcreteCategory.hom scK₀.f) (e₁.symm y)) := by
  intro R K₀ scK₀ Z₁ Z₂ e₁ e₂ r y
  -- Reconstruct the letI block inside the body so subsequent tactics that
  -- reference perI₁/h_mod_pi₁/perI₂/h_mod_pi₂ by name find them in scope.
  -- The values are definitionally equal to those baked into the goal's `•`
  -- via instance synthesis (same Pi.module / RingHom.toModule construction).
  letI perI₁ : ∀ i, Module R (Z₁ i) := fun i => by
    apply RingHom.toModule
    refine (C.left.presheaf.map (homOfLE ?_).op).hom
    let a0 : Fin ((ComplexShape.up ℕ).prev n + 1) := ⟨0, by omega⟩
    have h1 : ∏ᶜ (fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a)) ≤
      basicOpenCover (C := C) (U := U) ↑s₀ (i a0) := (Pi.π _ a0).le
    have h2 : basicOpenCover (C := C) (U := U) ↑s₀ (i a0) ≤ U :=
      basicOpen_le C.left (i a0 : Γ(C.left, U))
    exact h1.trans h2
  letI h_mod_pi₁ : Module R (∀ i, Z₁ i) := Pi.module _ _ _
  letI perI₂ : ∀ i, Module R (Z₂ i) := fun i => by
    apply RingHom.toModule
    refine (C.left.presheaf.map (homOfLE ?_).op).hom
    let a0 : Fin (n + 1) := ⟨0, by omega⟩
    have h1 : ∏ᶜ (fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a)) ≤
      basicOpenCover (C := C) (U := U) ↑s₀ (i a0) := (Pi.π _ a0).le
    have h2 : basicOpenCover (C := C) (U := U) ↑s₀ (i a0) ≤ U :=
      basicOpen_le C.left (i a0 : Γ(C.left, U))
    exact h1.trans h2
  letI h_mod_pi₂ : Module R (∀ i, Z₂ i) := Pi.module _ _ _
  funext j
  simp only [Pi.smul_apply]
  have hRel : (ComplexShape.up ℕ).prev n + 1 = n := by
    rcases n with _ | k
    · simp at hn
    · simp [ComplexShape.prev, ComplexShape.up_Rel]
  dsimp only [scK₀, K₀, cechCochain, cechComplexFunctor,
    toModuleKSheaf, toModuleKPresheaf_obj]
  simp [FormalCoproduct.cochainComplexFunctor,
    FormalCoproduct.cosimplicialObjectFunctor,
    AlgebraicTopology.alternatingCofaceMapComplex,
    AlgebraicTopology.AlternatingCofaceMapComplex.obj,
    AlgebraicTopology.AlternatingCofaceMapComplex.objD,
    AlgebraicTopology.AlternatingCofaceMapComplex.map,
    CochainComplex.of, FormalCoproduct.evalOp,
    CosimplicialObject.δ, e₁, e₂, ModuleCat.piIsoPi, dif_pos hRel]
  rw [show (limit.isoLimitCone
        ⟨ModuleCat.productCone Z₂, ModuleCat.productConeIsLimit Z₂⟩)
        = ModuleCat.piIsoPi Z₂ from rfl,
      show (limit.isoLimitCone
        ⟨ModuleCat.productCone Z₁, ModuleCat.productConeIsLimit Z₁⟩)
        = ModuleCat.piIsoPi Z₁ from rfl]
  show (ConcreteCategory.hom (ModuleCat.piIsoPi Z₂).hom) _ j =
      r • (ConcreteCategory.hom (ModuleCat.piIsoPi Z₂).hom) _ j
  rw [ModuleCat.piIsoPi_hom_ker_subtype_apply,
      ModuleCat.piIsoPi_hom_ker_subtype_apply]
  -- S6 step (a) [iter-092 CORRECTION]: `ModuleCat.hom_sum` IS in Mathlib
  -- (`Mathlib.Algebra.Category.ModuleCat.Basic` L359); earlier iterations
  -- (086+) misreported it as absent. We bind it as a local `have` with
  -- explicit ring instance (`R := k`) so the AddCommMonoid (M ⟶ N) synthesis
  -- succeeds during application (HOU fragility otherwise).
  have hom_sum_dist :
      ∀ {M N : ModuleCat.{u} k} {ι : Type}
        (f : ι → (M ⟶ N)) (s : Finset ι),
        ((∑ i ∈ s, f i) : M ⟶ N).hom = ∑ i ∈ s, (f i).hom :=
    @fun M N ι => ModuleCat.hom_sum (M := M) (N := N) (R := k)
  -- S6 step (b) [iter-093]: per-application form of `ModuleCat.hom_sum`.
  have key₁ :
      ∀ (F : Fin (n + 1) → ((∏ᶜ Z₁ : ModuleCat k) ⟶ (∏ᶜ Z₂ : ModuleCat k)))
        (z : ↑(∏ᶜ Z₁ : ModuleCat k)),
        ((∑ i, F i) : (∏ᶜ Z₁ : ModuleCat k) ⟶ (∏ᶜ Z₂ : ModuleCat k)).hom z =
          ∑ i, (F i).hom z := by
    intro F z
    rw [ModuleCat.hom_sum F Finset.univ]
    exact LinearMap.sum_apply Finset.univ (fun i => (F i).hom) z
  -- S6 step (b') [iter-094 BREAKTHROUGH]: fuse the eqToHom-wrapped ∘ₗ into a
  -- categorical `≫` composition. `ModuleCat.hom_comp f g : (f ≫ g).hom = g.hom ∘ₗ f.hom`,
  -- so `← ModuleCat.hom_comp` converts `(eqToHom_hom ∘ₗ (∑F).hom)` into
  -- `((∑F) ≫ eqToHom).hom`. This sidesteps the def-equal-not-syntactic-equal
  -- ModuleCat mismatch that defeated iter-093's `LinearMap.comp_apply` attempts.
  rw [← ModuleCat.hom_comp]
  -- S6 step (c) [iter-094 partial]: body-local helper combining
  -- `Preadditive.sum_comp` + `ModuleCat.hom_sum` + `LinearMap.sum_apply`
  -- into a single per-application distribution. Proved with FREE `G`/`E`/`z`
  -- (not bound to the goal's summand) so the proof itself avoids HOU. The
  -- BLOCKER remaining is that `rw [key₂]` / `simp_rw [key₂]` on the post-(b')
  -- goal still HOU-fails: the summand `(-1)^↑i • Pi.lift (fun i_1 ↦ ... uses
  -- outer i ...)` has shadowing `i` binders that Lean's HOU pattern matcher
  -- cannot resolve when trying to instantiate the `G` placeholder. See
  -- task_results/Cohomology_BasicOpenCech.lean.md for iter-094 attempt log.
  have key₂ :
      ∀ (G : Fin (n + 1) → ((∏ᶜ Z₁ : ModuleCat k) ⟶ (∏ᶜ Z₂ : ModuleCat k)))
        (E : (∏ᶜ Z₂ : ModuleCat k) ⟶ ModuleCat.of k ((i : Fin (n + 1) → ↑s₀) → ↑(Z₂ i)))
        (z : ↑(∏ᶜ Z₁ : ModuleCat k)),
        ((∑ i, G i) ≫ E).hom z = ∑ i, (G i ≫ E).hom z := by
    intro G E z
    rw [Preadditive.sum_comp]
    rw [ModuleCat.hom_sum (fun i => G i ≫ E) Finset.univ]
    exact LinearMap.sum_apply Finset.univ (fun i => (G i ≫ E).hom) z
  -- (c) iter-095: normalize all `ModuleCat.Hom.hom` to `ConcreteCategory.hom`
  -- so we can apply `← CategoryTheory.comp_apply` to absorb the outer
  -- `Pi.π Z₂ j` into the categorical composition.
  rw [show ModuleCat.Hom.hom = ConcreteCategory.hom (C := ModuleCat.{u} k) from rfl]
  -- iter-097 Step 2 (B1): rewrite both `(Pi.π Z₂ j).hom z` to
  -- `(piIsoPi Z₂).hom.hom z j` (== `e₂ z j` definitionally) via
  -- `← ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j`.
  simp_rw [← ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j]
  -- iter-099 Step 2: rewrite `r • _ j` to `(r • _) j` (Pi.smul_apply reverse)
  -- to lift the goal to family level, then `congrFun` removes `j` on both
  -- sides, then apply the iter-098 structural lemma
  -- `alternating_sum_pi_smul_aux_sum_comp` with Miller-pattern unification.
  -- Miller-pattern unification fills the four `_` placeholders (Z_int, G, E, s):
  --   ?Z_int unified against the codomain of `Pi.lift` summands.
  --   ?G : ι' → (∏ᶜ Z₁ ⟶ ∏ᶜ Z_int) := fun i ↦ (-1)^↑i • Pi.lift_thing_at_i.
  --   ?E := the trailing `eqToHom ⋯` (independent slot, bypasses iter-097 Attempt-5).
  --   ?s := Finset.univ.
  -- One remaining sub-goal: the per-summand R-linearity hypothesis `hG`.
  rw [← Pi.smul_apply (i := j)]
  refine congrFun
    (alternating_sum_pi_smul_aux_sum_comp Z₁ _ Z₂ Finset.univ _ _ e₁ e₂ ?_ r y) j
  -- iter-099 hG: per-summand R-linearity of `((-1)^↑i • Pi.lift_thing) ≫ eqToHom`.
  -- Partial chain established below: `simp only [ModuleCat.hom_comp,
  -- LinearMap.comp_apply]` distributes the composition's underlying linear-map
  -- application, exposing the smul-wrapped `Pi.lift_thing` separately from
  -- `eqToHom`. The residual extraction of `(-1)^↑i •` past `ModuleCat.Hom.hom`
  -- (via `ModuleCat.hom_smul` / `Linear.smul_comp`) does NOT simp-fire here,
  -- because Lean elaborates the polymorphic `(-1)^↑i` such that the
  -- `Monoid S`/`DistribMulAction S _`/`SMulCommClass k S _` typeclass chain
  -- for `ModuleCat.hom_smul` cannot synthesise. Awaits iter-100: either a
  -- forced-scalar `change` to pin `(-1)^↑i : ℤ`/`: k`, or a hand-typed
  -- distribution per `LinearMap.smul_apply` + `Pi.smul_apply` + `map_smul`
  -- with explicit scalar-type ascription, plus `presheafMap_restrict_collapse`
  -- to finish the residual presheaf-restriction commutativity.
  intro i _ r' y'
  simp only [ModuleCat.hom_comp, LinearMap.comp_apply]
  -- iter-100 partial: funext-based per-coordinate strategy. Six iter-099 routes for
  -- the scalar push-out exhausted at the polymorphic-`(-1)^↑i` typeclass synthesis
  -- stage. Iter-100 adds: `ModuleCat.hom_zsmul`, `Preadditive.zsmul_comp`,
  -- `Preadditive.nsmul_comp`, `Linear.smul_comp`, `dsimp only [hom_zsmul]`,
  -- `simp only [hom_zsmul, ...]`, and `change` with explicit-type ascription —
  -- all FAIL to find pattern matches on `((-1)^↑i • Pi.lift_thing)` despite
  -- `ModuleCat.hom_zsmul` being a `rfl` lemma applicable in standalone tests
  -- (verified via `lean_run_code`: works on `M ⟶ ∏ᶜ Z` for concrete `Z`).
  -- Diagnostic: `set h_sgn : ℤ := (-1)^(↑i : ℕ)` DOES substitute (confirming
  -- scalar IS in ℤ); `set h_sgn : k` does NOT substitute; so the scalar elaborates
  -- through the ℤ-SMul instance on `(∏ᶜ Z₁) ⟶ ∏ᶜ (anonymous closure)`. The
  -- anonymous closure codomain of `Pi.lift` is what blocks the discrimination
  -- tree's pattern unification — Lean can elaborate the pattern but cannot find
  -- the occurrence syntactically.
  -- PIVOT: `funext j'` directly pushes to per-coordinate level (the equation is
  -- already at the `∀ j', Z₂ j'` level since `e₂ _ : ∀ j, Z₂ j` and `r' • _` is
  -- componentwise Pi.smul). This is a structural advance toward the residual
  -- per-coordinate R-linearity via `piIsoPi_hom_ker_subtype_apply` + `Pi.smul_apply`
  -- + `Pi.lift_π_apply` + `presheafMap_restrict_collapse` (L425).
  funext j'
  -- Goal post-funext (verified iter-100 plan-pass via `lean_goal`):
  --   e₂ (eqToHom_hom (smul_thing.hom (e₁.symm (r' • y')))) j' =
  --     (r' • e₂ (eqToHom_hom (smul_thing.hom (e₁.symm y')))) j'
  -- where smul_thing = (-1)^↑i • Pi.lift_thing. The j'-projection isolates a
  -- single output coordinate. Plan for iter-101:
  --   1. simp only [Pi.smul_apply] on RHS to extract j': (r' • _) j' = r' • _ j'.
  --   2. rewrite e₂ _ j' via piIsoPi_hom_ker_subtype_apply to (Pi.π Z₂ j').hom _.
  --   3. ← ConcreteCategory.comp_apply to fuse Pi.π Z₂ j' ∘ eqToHom into a
  --      single morphism Pi.π Z₂_unfolded j' (eqToHom-natural in the projection).
  --   4. Pi.lift_π_apply to evaluate Pi.lift_thing ≫ Pi.π Z₂_unfolded j' = the
  --      j'-th summand (no Pi.lift anymore).
  --   5. The residual is R-linearity of (presheaf.map _).hom ∘ (Pi.π Z₁ _).hom,
  --      which `presheafMap_restrict_collapse` closes by routing through the
  --      RingHom.toModule R-action of presheaf restrictions.
  --   6. The (-1)^↑i • scalar commutes throughout because both sides retain it
  --      symmetrically — `congr 1` after factoring out h_sgn at the
  --      per-coordinate level (where the smul is on a concrete k-module).
  -- DEFERRED to iter-101+: closure of the per-coordinate R-linearity chain
  -- requires careful navigation of the eqToHom cast and the inner Pi.lift's
  -- second projection layer (toModuleKPresheaf C).map (Pi.lift _).op.
  sorry

-- Iter-078: lifted to 800000 because the iter-078 prover work on
-- `h_diff_pi_smul_f` (per-summand R-linearity of the Čech differential)
-- requires further tactic steps inside the deeply-nested `have` block;
-- each additional rewrite touching the `(r • _)` smul triggers
-- `HSMul R (Z_i j) ?_` synthesis whose `whnf` cost exceeds the default
-- 200000 budget at the theorem head.
set_option maxHeartbeats 800000 in
/-- Iter-060 (Phase A step 6 / Path 2 — **substantive Čech acyclicity attempt**):
the basic-open cover of an affine open `U` by a spanning subset `s ⊆ Γ(C.left, U)`
gives a Čech-acyclic cover for the `ModuleCat k`-valued structure sheaf
`toModuleKSheaf C`. This is the Stacks 01ED Čech-acyclicity theorem for affine
schemes in our setting.

**Mathematical content (Stacks 01ED route).** For each positive degree `n`,
exactness of the Čech cochain at degree `n` is a *local* property on the
spanning set `s`. Localising the Čech complex at any `f ∈ s` exhibits the
slice over `D(f)` as a Čech complex of an affine cover whose terminal vertex
`D(f) → D(f)` supplies an *extra degeneracy* (Mathlib's
`FormalCoproduct.extraDegeneracyCech`). By
`SimplicialObject.Augmented.ExtraDegeneracy.homotopyEquiv` the augmented
chain complex of the slice is homotopy equivalent to the constant complex on
the augmentation, hence exact in positive degrees. Re-globalising via
`exact_of_isLocalized_span` (Mathlib `RingTheory/LocalProperties/Exactness.lean`
L173) yields exactness of the *unlocalised* Čech complex at degree `n`.

The structural skeleton is:
* reduce `Subsingleton (cechCohomology n)` to `ExactAt (cechCochain) n` via
  `cechCohomology_subsingleton_of_cechCochain_exactAt`;
* the substantive `ExactAt n` is decomposed into three substeps tracked by
  separate `sorry`s, each annotated with the missing computational step.

**Transient sorries (iter-060)** — explicitly endorsed by the iteration
directive; each sorry names a substep. The substeps are:
  (a) **local exactness at `D(f)`** (extra-degeneracy invocation): given the
      cover-of-`D(f)` slice, build the augmented Čech simplicial object,
      apply `FormalCoproduct.extraDegeneracyCech` to obtain an
      `ExtraDegeneracy`, then transport via
      `ExtraDegeneracy.homotopyEquiv` and op-passage `CochainComplex.opEquivalence`
      to get cochain-level exactness in positive degrees;
  (b) **localised-Čech identification**: the localisation at `f` of the
      degree-`n` Čech cochain is the degree-`n` cochain of the cover-of-`D(f)`
      Čech complex, via iter-057+ identifications chained with
      `IsLocalizedModule.map_exact`;
  (c) **local-to-global** via `exact_of_isLocalized_span`: the assembled
      family of per-`f` local exactnesses lifts to global exactness.

The decomposition follows §"Branch A — Čech acyclicity" of
`analogies/cech-koszul-precedent.md`. -/
theorem basicOpenCover_isCechAcyclicCover_toModuleKSheaf
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat} (hU : IsAffineOpen U)
    (s : Set Γ(C.left, U)) (hs : Ideal.span s = ⊤) :
    IsCechAcyclicCover (toModuleKSheaf C)
        (basicOpenCover (C := C) (U := U) s) where
  subsingleton_cechCohomology n hn := by
    -- Step 0 (structural): reduce `Subsingleton (cechCohomology n)` to
    -- `ExactAt n` of the underlying Čech cochain complex via the iter-060
    -- helper `cechCohomology_subsingleton_of_cechCochain_exactAt`.
    refine cechCohomology_subsingleton_of_cechCochain_exactAt (n := n) ?_
    -- The goal is now
    --   `(cechCochain C (toModuleKSheaf C) (basicOpenCover s)).ExactAt n`.
    -- Iter-061 decomposition: the Stacks 01ED extra-degeneracy + local-to-global
    -- argument has three substeps tracked by separate labelled `sorry`s.
    --
    -- ===========================================================================
    -- Substep (a) — Extra-degeneracy on the slice cover of `D(f)`.
    -- ===========================================================================
    -- For each `f ∈ s`, the slice cover of `D(f)` by the family
    --   `{basicOpenCover s f' ⊓ D(f)}_{f' ∈ s}`
    -- contains `D(f) ⊓ D(f) = D(f)` itself (at index `f' = f`), so the
    -- terminal vertex maps to `D(f)` via the identity section
    -- `D(f) → D(f)`. By `FormalCoproduct.extraDegeneracyCech`
    -- (`Mathlib/CategoryTheory/Limits/FormalCoproducts/ExtraDegeneracy.lean` L92),
    -- the augmented Čech simplicial object on this slice has an
    -- `ExtraDegeneracy`. By `SimplicialObject.Augmented.ExtraDegeneracy.homotopyEquiv`
    -- (`Mathlib/AlgebraicTopology/ExtraDegeneracy.lean` L328), the associated
    -- alternating-face-map chain complex is homotopy-equivalent to the
    -- constant complex on the augmentation. Op-passage through
    -- `CochainComplex.opEquivalence` then yields cochain-level exactness in
    -- positive degrees. We state substep (a) as a concrete `ExactAt n`
    -- claim on the slice cover Čech cochain complex:
    have h_a : ∀ (f : s),
        (cechCochain C (toModuleKSheaf C)
            (fun (f' : s) => basicOpenCover (C := C) (U := U) s f' ⊓
              C.left.basicOpen (f : Γ(C.left, U)))).ExactAt n := by
      intro f
      -- The terminal vertex of the slice cover is at `f' = f`:
      --   `basicOpenCover s f ⊓ C.left.basicOpen f.1 = D(f) ⊓ D(f) = D(f)`.
      -- Plug into `FormalCoproduct.extraDegeneracyCech` with `i₀ := f`,
      -- extract `homotopyEquiv`, op-pass, read off `ExactAt n` for `0 < n`.
      sorry  -- substep (a) infrastructure: augmented Čech simplicial object
             -- + extraDegeneracyCech + homotopyEquiv + CochainComplex.opEquivalence
    -- ===========================================================================
    -- Substep (b) — Localised-Čech identification.
    -- ===========================================================================
    -- For each `f ∈ s`, the slice cover Čech cochain complex above is
    -- isomorphic (in `ModuleCat k`) to the localisation at `f` of the
    -- original Čech cochain complex `K`. Cochain-factor-wise:
    --   `(slice cover).X^n = ∏_x F(⨅ k, basicOpenCover s (x k) ⊓ D(f))`
    --                      = `∏_x F(D(f · ∏ k, (x k).1))`              (Stacks identity)
    --                      = `∏_x Localization.Away (f · ∏ k, (x k).1) Γ(C.left, U)`
    --                      = `∏_x Γ(C.left, ⨅ k, basicOpenCover s (x k))[1/f]`
    --                      = `K.X^n [1/f]`.
    -- The first equality is iter-057 (`basicOpenCover_finset_inf'_eq_basicOpen_prod`)
    -- applied to the augmented index `{f} ∪ image(x)`. The second is
    -- iter-059 (`basicOpenCover_finset_inf'_isLocalization`). The third is
    -- the universal property of localisation (transitivity of localisation:
    -- `R[1/(f·g)] = R[1/g][1/f]` when `f` is also among the generators).
    -- The differential identification uses `IsLocalizedModule.map_exact`
    -- (`Mathlib/Algebra/Module/LocalizedModule/Exact.lean` L56) to transport
    -- the cochain-level identification to the slice differential.
    --
    -- ===========================================================================
    -- Substep (c) — Local-to-global via `exact_of_isLocalized_span`.
    -- ===========================================================================
    -- The combined data from substeps (a) and (b) — per-`f` exactness at
    -- degree `n` of the slice cover Čech complex, which by substep (b) is
    -- the localisation of `K.sc n` — fits the hypothesis of
    -- `exact_of_isLocalized_span s hs ...`
    -- (`Mathlib/RingTheory/LocalProperties/Exactness.lean` L173) viewing
    -- the cochain factors as `Γ(C.left, U)`-modules through their natural
    -- module structure. The conclusion is `Function.Exact ⇑(K.sc n).f ⇑(K.sc n).g`,
    -- which converts back to `K.ExactAt n` via
    -- `ShortComplex.ShortExact.moduleCat_exact_iff_function_exact` and
    -- `HomologicalComplex.exactAt_iff`.
    --
    -- This combined assembly remains as a single transient sorry: it
    -- requires constructing the cochain-level localisation iso (substep (b)
    -- ≈ a `noncomputable def` for the localised Čech short complex plus
    -- its identification iso) and routing the ring-base mismatch
    -- (`(K.sc n).f.hom` is `k`-linear; `exact_of_isLocalized_span` consumes
    -- `Γ(C.left, U)`-linear maps — they coincide as set-functions, but the
    -- type-level reconciliation is non-trivial).
    --
    -- For iter-061, substep (a)'s claim is concretely stated above and
    -- substep (b)+(c)'s assembly remains as the second labelled sorry below.
    -- We perform the mechanical conversion `K.ExactAt n ↔ Function.Exact ⇑f ⇑g`
    -- before the sorry, so the remaining content is precisely the
    -- "transport per-f exactness through the localisation iso then apply
    -- the local-to-global principle" assembly step.
    rw [HomologicalComplex.exactAt_iff,
        ShortComplex.ShortExact.moduleCat_exact_iff_function_exact]
    -- Goal:
    --   `Function.Exact ⇑(ConcreteCategory.hom ((K).sc n).f)
    --                   ⇑(ConcreteCategory.hom ((K).sc n).g)`
    -- where `K := cechCochain C (toModuleKSheaf C) (basicOpenCover s)`.
    -- ===========================================================================
    -- Iter-062 substantive scaffolding (a): convert `h_a` into `Function.Exact` form.
    -- ===========================================================================
    -- The same `HomologicalComplex.exactAt_iff` +
    -- `ShortComplex.ShortExact.moduleCat_exact_iff_function_exact` chain that
    -- converts our goal also converts each per-`f` slice-cover `ExactAt n`
    -- hypothesis into a per-`f` `Function.Exact` statement at the
    -- function-level. This is closed under `← rw` (no new sorry).
    have h_a_fun : ∀ (f : s),
        Function.Exact
          ⇑(ConcreteCategory.hom (HomologicalComplex.sc
              (cechCochain C (toModuleKSheaf C)
                (fun (f' : s) => basicOpenCover (C := C) (U := U) s f' ⊓
                  C.left.basicOpen (f : Γ(C.left, U)))) n).f)
          ⇑(ConcreteCategory.hom (HomologicalComplex.sc
              (cechCochain C (toModuleKSheaf C)
                (fun (f' : s) => basicOpenCover (C := C) (U := U) s f' ⊓
                  C.left.basicOpen (f : Γ(C.left, U)))) n).g) := by
      intro f
      rw [← ShortComplex.ShortExact.moduleCat_exact_iff_function_exact,
          ← HomologicalComplex.exactAt_iff]
      exact h_a f
    -- ===========================================================================
    -- Iter-062 substantive scaffolding (b): outline the local-to-global route.
    -- ===========================================================================
    -- The closure of the remaining goal proceeds via Mathlib's local-to-global
    -- principle for exactness `exact_of_isLocalized_span` applied to the
    -- ring `R := Γ(C.left, U)`, the spanning subset `s ⊆ R`, and the
    -- `R`-linear maps `(K.sc n).f.hom` and `(K.sc n).g.hom` (treated as
    -- `R`-linear via the `Module R ((K.sc n).X i)`-structure obtained from
    -- the cochain factor's natural `Γ(C.left, ⋂_x …)`-module structure
    -- precomposed with the algebra map `R → Γ(C.left, ⋂_x …)`).
    -- The required input is, for each `f ∈ s`, a `Function.Exact`
    -- statement on the localised cochain factors at `f`. By the
    -- cochain-factor identification chain (iter-057 + iter-058 + iter-059
    -- + Mathlib `Localization.localizationLocalization` + product-localisation
    -- commutation), the localised `(K.sc n).X i [1/f]` identifies with the
    -- slice-cover Čech `.X i` at the same degree, and consequently the
    -- localised differential identifies with the slice-cover differential.
    -- This identification + `IsLocalizedModule.map_exact` transports
    -- `h_a_fun f` (which is the slice-cover Čech `Function.Exact` at
    -- degree `n`) to `Function.Exact` of the localised differential.
    -- The infinite-set subtlety (`s` is `Set`, not `Finset`) is sidestepped
    -- because `Ideal.span s = ⊤` already implies a *finite* subset spans
    -- the unit ideal — `exact_of_isLocalized_span` only consumes the per-`r`
    -- localised exactness data and the spanning hypothesis, not finiteness
    -- of `s` directly.
    -- ===========================================================================
    -- Substep (b1) — install the `Module Γ(C.left, U)` instances on each
    -- cochain factor `(K.sc n).X i`.
    -- ===========================================================================
    -- The cochain factor `K.X i = ∏_{x : Fin (i+1) → s} Γ(C.left, ⋂_k 𝒰(x k))`
    -- carries a `Γ(C.left, U)`-module structure pointwise, since each
    -- `Γ(C.left, V)` for `V ≤ U` is a `Γ(C.left, U)`-algebra via the
    -- restriction map (iter-058's `basicOpenCover_finset_inf'_le` supplies
    -- the inclusion `V ≤ U`, iter-006's `algebraSection` supplies the
    -- algebra structure on each factor).
    --
    -- ===========================================================================
    -- Substep (b2) — exhibit `slice_K.X i` as `IsLocalizedModule.Away f.1`
    -- of `(K.sc n).X i` for each `f ∈ s`.
    -- ===========================================================================
    -- The cochain-factor identification chain (iter-057 + iter-058 + iter-059
    -- + Mathlib `Localization.localizationLocalization` + product-localisation
    -- commutation) gives
    --   `slice_K.X i = ∏_x Γ(C.left, ⋂_k 𝒰_slice(x k))`
    --                = `∏_x Γ(C.left, ⋂_k 𝒰(x k) ⊓ D(f))`
    --                = `∏_x Γ(C.left, ⋂_k 𝒰(x k))[1/f]`        (iter-058 + iter-059)
    --                = `(∏_x Γ(C.left, ⋂_k 𝒰(x k)))[1/f]`     (product-loc commutation)
    --                = `(K.X i)[1/f]`.
    -- The pointwise localisation map (component-wise restriction map
    -- `Γ(C.left, V) → Γ(C.left, V')` for `V' = V ⊓ D(f) ≤ V`) is the canonical
    -- localisation map and an `IsLocalizedModule.Away f.1` instance.
    --
    -- ===========================================================================
    -- Substep (c) — apply `exact_of_isLocalized_span s hs ... h_a_fun`.
    -- ===========================================================================
    -- With the data from (b1) and (b2), `exact_of_isLocalized_span` packages
    -- the per-`f` exactness `h_a_fun f` into the global `Function.Exact`
    -- conclusion. The remaining work is purely the unification of the per-`f`
    -- input shape with the conclusion of `IsLocalizedModule.map ... F`
    -- via the iso from (b2) and `IsLocalizedModule.map_exact`.
    -- ===========================================================================
    -- Iter-063 progress: explicit finite-subspanning extraction + obstruction
    -- diagnosis.
    -- ===========================================================================
    -- The localisation-commutes-with-products subtlety identified by the
    -- iter-061 prover (Attempt 3) is genuine and severe: for the cochain
    -- factor `K.X i = ∏ᶜ_{x : Fin (i+1) → s} P.obj (op (∏ᶜ_k 𝒰(x k)))` in
    -- `ModuleCat k` (where `P` is the underlying presheaf of `toModuleKSheaf C`),
    -- the index set `Fin (i+1) → s` is *infinite* when `s` is infinite, and
    -- `LocalizedModule (powers f) (∏ᶜ_x M_x) ≄ ∏ᶜ_x LocalizedModule (powers f) M_x`
    -- in general for infinite products. So `slice_K.X i = ∏_x Γ(V_x ⊓ D(f))`
    -- is NOT literally `(K.X i)[1/f]` — the natural map between them is
    -- *not* an `IsLocalizedModule.Away f.1`. Iter-062's substep (b2) plan
    -- ("install `IsLocalizedModule.Away f.1` instances on the product")
    -- requires reducing to a finite index-set first.
    --
    -- Iter-063 lands the finite-subspanning extraction as a structural fact
    -- inside the proof: `Ideal.span s = ⊤` implies the existence of a
    -- *finite* subset `s₀ ⊆ s` with `Ideal.span ↑s₀ = ⊤` via Mathlib's
    -- `Ideal.span_eq_top_iff_finite`. The remaining substep work uses `s₀`
    -- (a `Finset`, hence `Fin (i+1) → ↑s₀` is finite) to install the
    -- product-localisation commutation. The transport step from `s₀`-cover
    -- exactness to `s`-cover exactness is itself non-trivial: it requires
    -- a Čech-complex refinement comparison (`s₀ ⊆ s` ⇒ Čech-cohomology
    -- equality), which Mathlib does not currently expose directly but can
    -- be derived from the universal property of products via `Pi.eqOfPi`
    -- + the per-component (cofinal) refinement.
    have hs_fin : ∃ s' : Finset Γ(C.left, U), (↑s' : Set Γ(C.left, U)) ⊆ s ∧
        Ideal.span (↑s' : Set Γ(C.left, U)) = ⊤ :=
      (Ideal.span_eq_top_iff_finite (s := s)).mp hs
    -- ===========================================================================
    -- Substep (b1-b2-c) merged with the iter-063 finite-subspanning data.
    -- ===========================================================================
    -- The route now has three components: (i) Čech-cohomology refinement
    -- transport `s → s₀` (using `hs_fin`); (ii) substep (b2) at the finite
    -- cover `s₀` where the product-localisation commutation succeeds; and
    -- (iii) `exact_of_isLocalized_span` on `s₀` together with the per-`f`
    -- slice-cover exactness `h_a_fun ⟨f, hs_fin.choose_spec.1 hf⟩` for
    -- `f ∈ s₀ ⊆ s`.
    --
    -- The Čech-refinement transport (i) is the new iter-064+ work; it has
    -- the form
    -- `Function.Exact (K(s).sc n).f (K(s).sc n).g ↔
    --    Function.Exact (K(s₀).sc n).f (K(s₀).sc n).g`
    -- under `hs_fin`. A natural framing: there is a *cochain-complex map*
    -- `K(s) → K(s₀)` (induced by the cofinal inclusion `s₀ ⊆ s` and the
    -- product universal property), and exactness transports along it
    -- iff one shows the map is a "Čech equivalence" — equivalently, by
    -- the lattice-supremum agreement `⨆ basicOpenCover s = U = ⨆ basicOpenCover s₀`,
    -- the two covers compute the same Čech cohomology via the
    -- `cechCohomology` carrier.
    -- ===========================================================================
    -- Iter-064: component (i) scaffolding — Čech-cohomology refinement transport.
    -- ===========================================================================
    -- Extract the finite subspanning set `s₀` and its properties.
    obtain ⟨s₀, h_sub, h_top⟩ := hs_fin
    -- Introduce shorthand for the two Čech cochain complexes.
    let K := cechCochain C (toModuleKSheaf C) (basicOpenCover s)
    let K₀ := cechCochain C (toModuleKSheaf C)
      (basicOpenCover (C := C) (U := U) (↑s₀ : Set Γ(C.left, U)))
    -- The inclusion `↑s₀ ⊆ s` induces a cochain-complex map `K → K₀` by
    -- precomposing multi-indices.  Exactness transports across this map because
    -- both covers generate the same sieve on `U` (`⨆ basicOpenCover s = U =
    -- ⨆ basicOpenCover ↑s₀`).  The transport is stated as a `have` below;
    -- closing it requires either a direct homological-algebra argument
    -- (quasi-isomorphism induced by the refinement) or a reduction to the
    -- sheaf-theoretic fact that Čech cohomology depends only on the generated
    -- sieve.  Mathlib does not yet expose this comparison directly.
    have h_transport :
      Function.Exact
        ⇑(ConcreteCategory.hom (HomologicalComplex.sc K₀ n).f)
        ⇑(ConcreteCategory.hom (HomologicalComplex.sc K₀ n).g) →
      Function.Exact
        ⇑(ConcreteCategory.hom (HomologicalComplex.sc K n).f)
        ⇑(ConcreteCategory.hom (HomologicalComplex.sc K n).g) := by
      -- =========================================================================
      -- Iter-065 scaffolding: Čech-cohomology refinement transport `s → s₀`.
      -- =========================================================================
      intro h_exact_K₀
      -- Step 1: the inclusion `↑s₀ ↪ s` induces a map of index sets
      -- `Fin (i+1) → ↑s₀ → Fin (i+1) → s` for each degree `i`.  By the universal
      -- property of the categorical product, this gives a projection map
      -- `π_i : K.X i → K₀.X i` in `ModuleCat k` (project onto the smaller index
      -- set).  These assemble into a cochain-complex map `π : K → K₀` because
      -- the Čech differential is natural in the index set.
      --
      -- **Iter-065 concrete construction** of `π`.  We assemble it through the
      -- Mathlib API:
      --   1. The inclusion `↑s₀ ⊆ s` gives a `FormalCoproduct`-morphism
      --      `g_FC : ⟨↑s₀, basicOpenCover ↑s₀⟩ ⟶ ⟨s, basicOpenCover s⟩`
      --      (function `j ↦ ⟨j.1, h_sub j.2⟩` on indices, identity on objects
      --      since `basicOpenCover s ⟨j.1, _⟩ = C.left.basicOpen j.1 =
      --      basicOpenCover ↑s₀ j`).
      --   2. `Limits.FormalCoproduct.cechFunctor` applied to `g_FC` produces a
      --      morphism of simplicial objects in `FormalCoproduct (Opens _)`.
      --   3. `cosimplicialObjectFunctor` precomposes with `_.rightOp`, hence is
      --      *contravariant* in the simplicial object.  Applying it via
      --      `whiskeringLeft` yields a natural transformation
      --      `cosimplicialObjectFunctor (mk s _).cech ⟶
      --       cosimplicialObjectFunctor (mk ↑s₀ _).cech`.
      --   4. Whiskering with `alternatingCofaceMapComplex` and evaluating at
      --      the underlying presheaf of `toModuleKSheaf C` gives the desired
      --      cochain-complex morphism `K ⟶ K₀`.
      let g_FC :
          (Limits.FormalCoproduct.mk (↑s₀ : Set Γ(C.left, U))
              (basicOpenCover (C := C) (U := U) (↑s₀ : Set Γ(C.left, U)))) ⟶
          (Limits.FormalCoproduct.mk s
              (basicOpenCover (C := C) (U := U) s)) :=
        { f := fun j => ⟨j.1, h_sub j.2⟩
          φ := fun _ => 𝟙 _ }
      let g_simp :
          (Limits.FormalCoproduct.mk (↑s₀ : Set Γ(C.left, U))
              (basicOpenCover (C := C) (U := U)
                (↑s₀ : Set Γ(C.left, U)))).cech ⟶
          (Limits.FormalCoproduct.mk s
              (basicOpenCover (C := C) (U := U) s)).cech :=
        Limits.FormalCoproduct.cechFunctor.map g_FC
      let π : HomologicalComplex.Hom K K₀ :=
        ((Functor.whiskerLeft (Limits.FormalCoproduct.evalOp _ (ModuleCat.{u} k))
            ((Functor.whiskeringLeft _ _ _).map g_simp.rightOp)) ◫
          𝟙 (AlgebraicTopology.alternatingCofaceMapComplex (ModuleCat.{u} k))).app
          ((sheafToPresheaf _ _).obj (toModuleKSheaf C))
      -- Step 2: each component `π_i` is a split surjection in `ModuleCat k`.
      -- The splitting is given by extending a function `Fin (i+1) → ↑s₀` to
      -- `Fin (i+1) → s` by choosing arbitrary values on the complement of `↑s₀`
      -- (possible because `s` is non-empty, as `Ideal.span s = ⊤`).
      --
      -- Iter-066: the categorical content is captured by
      -- `splitEpi_pi_lift_of_injective` (defined above), which says a product
      -- projection induced by an injection of index sets is split in
      -- `ModuleCat k`. The remaining obligation is to identify `π.f i` as such
      -- a product projection — namely
      -- `Pi.lift (fun j' : Fin(i+1) → ↑s₀ => Pi.π M (g_FC.f ∘ j'))` for the
      -- family `M : (Fin(i+1) → s) → ModuleCat k` given by
      -- `j ↦ F.obj (op (∏ᶜ_a basicOpenCover s (j a)))`. From the simp lemmas of
      -- `evalOp` (`Mathlib/CategoryTheory/Limits/FormalCoproducts/Basic.lean` L383),
      -- of `cechFunctor` (`.../FormalCoproducts/Cech.lean` L194), and of
      -- `alternatingCofaceMapComplex`, `π.f i` reduces to exactly this form
      -- (the `≫ F.map (𝟙).op` factor collapses by `F.map_id` since
      -- `(powerMap g_FC (Fin (i+1))).φ j' = 𝟙` for our `g_FC`).
      --
      -- Decomposing into named subobligations:
      have h_inj : Function.Injective (g_FC.f) := fun a b hab => by
        -- g_FC.f j = ⟨j.1, h_sub j.2⟩ ∈ s; injective because Subtype.val is.
        have : (g_FC.f a).1 = (g_FC.f b).1 := congrArg Subtype.val hab
        exact Subtype.ext this
      have h_inj' (i : ℕ) :
          Function.Injective (fun (j' : Fin (i + 1) → ↑s₀) => g_FC.f ∘ j') :=
        fun a b hab => funext (fun x => h_inj (congrFun hab x))
      -- The actual identification of `π.f i` with the product projection (and
      -- thus the SplitEpi) remains to be carried out. The helper
      -- `splitEpi_pi_lift_of_injective` reduces the work to this identification
      -- step. See `task_results/BasicOpenCech.lean.md` for the iter-066
      -- analysis of the simp lemmas needed.
      have h_π_split (i : ℕ) : SplitEpi (π.f i) := by
        -- Approach: use convert with the helper, then close the equality subgoal
        -- via simp lemmas for evalOp, cechFunctor, and alternatingCofaceMapComplex.
        convert splitEpi_pi_lift_of_injective _ (fun j' => g_FC.f ∘ j') (h_inj' i) using 2
        · -- After convert, the goal is π.f i = Pi.lift (...).  Simplify the
          -- left-hand side using the simps lemmas for evalOp, cechFunctor,
          -- and alternatingCofaceMapComplex, then unfold g_simp and use the
          -- powerMap simps.  The remaining identity morphisms are eliminated
          -- pointwise after congr+funext.
          simp [π]
          rw [show g_simp = FormalCoproduct.cechFunctor.map g_FC by rfl]
          simp [FormalCoproduct.cechFunctor_map_app, FormalCoproduct.powerMap_f,
            FormalCoproduct.powerMap_φ]
          dsimp [g_FC]
          congr
          funext i_1
          erw [Limits.Pi.map_id, CategoryTheory.op_id, CategoryTheory.Functor.map_id,
            CategoryTheory.Category.comp_id]
      -- Step 3: the kernel of `π` at degree `i` is the product of the factors
      -- indexed by `x : Fin (i+1) → s` that are *not* in the image of
      -- `Fin (i+1) → ↑s₀`.  The kernel complex is acyclic in positive degrees
      -- because it is a Čech complex of a cover that is a refinement of a cover
      -- with a terminal object (the extra-degeneracy argument applies to the
      -- kernel once `s` is reduced modulo `↑s₀`).  Alternatively, one can use
      -- the sheaf-theoretic fact that Čech cohomology depends only on the
      -- generated sieve, and both `s` and `s₀` generate the same sieve `U`.
      --
      -- Step 4: from the short exact sequence of complexes
      -- `0 → ker(π) → K → K₀ → 0` and exactness of `K₀` at degree `n`, the
      -- long exact sequence in cohomology gives exactness of `K` at degree `n`.
      -- A direct diagram-chase argument (or `HomologicalComplex.homologyMap`)
      -- closes the goal.
      sorry
    -- ===========================================================================
    -- Iter-064: component (ii) scaffolding — `exact_of_isLocalized_span` on `s₀`.
    -- ===========================================================================
    -- We now prove exactness of `K₀` using the finite-spanning local-to-global
    -- principle.  Because `s₀` is finite, the cochain factors of `K₀` are
    -- *finite* products, so product-localisation commutation holds and
    -- `IsLocalizedModule.Away f.1` instances can be installed.
    have h_K₀_exact : Function.Exact
        ⇑(ConcreteCategory.hom (HomologicalComplex.sc K₀ n).f)
        ⇑(ConcreteCategory.hom (HomologicalComplex.sc K₀ n).g) := by
      -- Step 1: install `Module Γ(C.left, U)` instances on each cochain factor
      -- of `K₀`.  Each factor `Γ(C.left, V)` for `V ≤ U` is a
      -- `Γ(C.left, U)`-algebra via the restriction map; the finite product
      -- inherits the pointwise `Γ(C.left, U)`-module structure.
      --
      -- Step 2: for each `f ∈ ↑s₀`, the slice cover Čech complex at `f`
      -- (indexed by `↑s₀`) is exact in degree `n` by the same extra-degeneracy
      -- argument as substep (a): the cover of `D(f)` contains `D(f)` itself
      -- (at index `f`), so the augmented complex contracts.  This is stated
      -- as `h_a₀` below.
      have h_a₀ : ∀ (f : ↑s₀),
          (cechCochain C (toModuleKSheaf C)
            (fun (f' : ↑s₀) => basicOpenCover (C := C) (U := U) (↑s₀ : Set Γ(C.left, U)) f' ⊓
              C.left.basicOpen (f : Γ(C.left, U)))).ExactAt n := by
        intro f
        -- Same extra-degeneracy argument as `h_a`: the terminal vertex of the
        -- `↑s₀`-indexed slice cover is at `f' = f`, giving `D(f) ⊓ D(f) = D(f)`.
        sorry  -- substep (a) for `s₀`: extra-degeneracy on `s₀`-indexed slice cover
      have h_a₀_fun : ∀ (f : ↑s₀),
          Function.Exact
            ⇑(ConcreteCategory.hom (HomologicalComplex.sc
                (cechCochain C (toModuleKSheaf C)
                  (fun (f' : ↑s₀) => basicOpenCover (C := C) (U := U) (↑s₀ : Set Γ(C.left, U)) f' ⊓
                    C.left.basicOpen (f : Γ(C.left, U)))) n).f)
            ⇑(ConcreteCategory.hom (HomologicalComplex.sc
                (cechCochain C (toModuleKSheaf C)
                  (fun (f' : ↑s₀) => basicOpenCover (C := C) (U := U) (↑s₀ : Set Γ(C.left, U)) f' ⊓
                    C.left.basicOpen (f : Γ(C.left, U)))) n).g) := by
        intro f
        rw [← ShortComplex.ShortExact.moduleCat_exact_iff_function_exact,
            ← HomologicalComplex.exactAt_iff]
        exact h_a₀ f
      -- Step 3: for each `f ∈ ↑s₀`, identify the localisation of `K₀.X i` at
      -- `f` with the `↑s₀`-indexed slice-cover term at the same degree.
      -- Because `s₀` is finite, `Fin (i+1) → ↑s₀` is finite, and the
      -- product-localisation commutation
      --   `LocalizedModule (powers f) (∏ᶜ_x Γ(V_x)) ≅ ∏ᶜ_x Γ(V_x ⊓ D(f))`
      -- holds.  This gives `IsLocalizedModule.Away f.1` instances on the
      -- cochain-complex maps of `K₀`, viewed as `Γ(C.left, U)`-linear maps.
      --
      -- Step 4: transport `h_a₀_fun f` (exactness of the slice-cover Čech
      -- complex) across the product-localisation identification via
      -- `IsLocalizedModule.map_exact` to obtain exactness of the localised
      -- differential of `K₀` at `f`.
      --
      -- Step 5: apply `exact_of_isLocalized_span ↑s₀ h_top ...` to conclude
      -- global exactness of `K₀`.
      -- =========================================================================
      -- Iter-065 scaffolding: structured attack on `exact_of_isLocalized_span`.
      -- =========================================================================
      let R := Γ(C.left, U)
      let scK₀ := HomologicalComplex.sc K₀ n
      -- =========================================================================
      -- Iter-072 prover refactor: hoist `Z_i`, `e_i`, `h_mod_pi_i` to the outer
      -- scope so the LinearEquiv handles `e_i` are available for `Equiv.smul_def`
      -- unfolding in `map_smul'` below.
      -- =========================================================================
      -- The pointwise product types for each cochain degree.
      let Z₁ := fun (i : Fin ((ComplexShape.up ℕ).prev n + 1) → ↑s₀) =>
        ModuleCat.of k (C.left.presheaf.obj
          (Opposite.op (∏ᶜ fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a))))
      let Z₂ := fun (i : Fin (n + 1) → ↑s₀) =>
        ModuleCat.of k (C.left.presheaf.obj
          (Opposite.op (∏ᶜ fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a))))
      let Z₃ := fun (i : Fin (n + 2) → ↑s₀) =>
        ModuleCat.of k (C.left.presheaf.obj
          (Opposite.op (∏ᶜ fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a))))
      -- LinearEquivs `∏ᶜ Z_i ≃ₗ[k] (∀ i, Z_i)` from Mathlib's `ModuleCat.piIsoPi`.
      let e₁ := (ModuleCat.piIsoPi Z₁).toLinearEquiv
      let e₂ := (ModuleCat.piIsoPi Z₂).toLinearEquiv
      let e₃ := (ModuleCat.piIsoPi Z₃).toLinearEquiv
      -- Pointwise `R`-module structure on each `∀ i, Z_i`.
      -- Each component `Z_i k = Γ(C.left, V_k)` is an `R`-algebra (via restriction),
      -- hence an `R`-module; the product inherits the pointwise structure.
      --
      -- ITER-080 refactor: the per-i Module instance is now bound as a named
      -- `letI perI_n` and `h_mod_pi_n` is constructed via `Pi.module` which
      -- picks up `perI_n` via typeclass synthesis on `[∀ i, Module R (β i)]`.
      -- This makes `Pi.smul_apply` fire on `h_mod_pi_n.toSMul.smul r _ j`
      -- because the per-i SMul is now visible to typeclass search (whereas the
      -- previous anonymous per-i builder was unreachable). Semantic content is
      -- preserved byte-for-byte: each `perI_n` is the same `fun i => by ...`
      -- term that previously sat inside `Pi.module`'s instance argument.
      letI perI₁ : ∀ i, Module R (Z₁ i) := fun i => by
        apply RingHom.toModule
        refine (C.left.presheaf.map (homOfLE ?_).op).hom
        let a0 : Fin ((ComplexShape.up ℕ).prev n + 1) := ⟨0, by omega⟩
        have h1 : ∏ᶜ (fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a)) ≤
          basicOpenCover (C := C) (U := U) ↑s₀ (i a0) := (Pi.π _ a0).le
        have h2 : basicOpenCover (C := C) (U := U) ↑s₀ (i a0) ≤ U :=
          basicOpen_le C.left (i a0 : Γ(C.left, U))
        exact h1.trans h2
      letI h_mod_pi₁ : Module R (∀ i, Z₁ i) := Pi.module _ _ _
      letI perI₂ : ∀ i, Module R (Z₂ i) := fun i => by
        apply RingHom.toModule
        refine (C.left.presheaf.map (homOfLE ?_).op).hom
        let a0 : Fin (n + 1) := ⟨0, by omega⟩
        have h1 : ∏ᶜ (fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a)) ≤
          basicOpenCover (C := C) (U := U) ↑s₀ (i a0) := (Pi.π _ a0).le
        have h2 : basicOpenCover (C := C) (U := U) ↑s₀ (i a0) ≤ U :=
          basicOpen_le C.left (i a0 : Γ(C.left, U))
        exact h1.trans h2
      letI h_mod_pi₂ : Module R (∀ i, Z₂ i) := Pi.module _ _ _
      letI perI₃ : ∀ i, Module R (Z₃ i) := fun i => by
        apply RingHom.toModule
        refine (C.left.presheaf.map (homOfLE ?_).op).hom
        let a0 : Fin (n + 2) := ⟨0, by omega⟩
        have h1 : ∏ᶜ (fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a)) ≤
          basicOpenCover (C := C) (U := U) ↑s₀ (i a0) := (Pi.π _ a0).le
        have h2 : basicOpenCover (C := C) (U := U) ↑s₀ (i a0) ≤ U :=
          basicOpen_le C.left (i a0 : Γ(C.left, U))
        exact h1.trans h2
      letI h_mod_pi₃ : Module R (∀ i, Z₃ i) := Pi.module _ _ _
      -- `Module R` instances on `scK₀.X_i`, transported via `e_i` from the
      -- pointwise structure on `∀ i, Z_i`. We keep `convert h` (rather than
      -- `exact h`) as a defensive measure: after `dsimp`, the types match
      -- definitionally, but `convert` succeeds even if a residual coercion
      -- appears. The `Equiv.smul_def` rewrites in `map_smul'` below depend on
      -- the resulting smul being literally `e_i.toEquiv.smul R`; iter-071
      -- verified this holds in practice (the LinearEquiv on `scK₀.X_i` matches
      -- the pi-iso target after dsimp).
      -- ITER-077: use `letI` (not `have`) so the module instance registers
      -- with typeclass synthesis, and bind it to the literal
      -- `e_i.toAddEquiv.module R` term so the underlying smul is
      -- `e_i.toEquiv.smul R` (which gives `r • x = e_i.symm (r • e_i x)` by
      -- `rfl` per `Equiv.smul_def` being `rfl`).
      letI h_mod_X₁ : Module R scK₀.X₁ := by
        dsimp only [scK₀, K₀, cechCochain, cechComplexFunctor,
          toModuleKSheaf, toModuleKPresheaf_obj]
        letI := h_mod_pi₁
        exact e₁.toAddEquiv.module R
      letI h_mod_X₂ : Module R scK₀.X₂ := by
        dsimp only [scK₀, K₀, cechCochain, cechComplexFunctor,
          toModuleKSheaf, toModuleKPresheaf_obj]
        letI := h_mod_pi₂
        exact e₂.toAddEquiv.module R
      letI h_mod_X₃ : Module R scK₀.X₃ := by
        -- `scK₀.X₃ = K₀.X ((ComplexShape.up ℕ).next n)` doesn't reduce to
        -- `K₀.X (n + 1)` by `rfl` — `ComplexShape.next` is opaque (defined
        -- via `Classical.choose` over `Rel`). Pre-rewrite via `CochainComplex.next`.
        have h_eq : scK₀.X₃ = K₀.X (n + 1) := by
          change K₀.X ((ComplexShape.up ℕ).next n) = K₀.X (n + 1)
          rw [CochainComplex.next]
        rw [h_eq]
        dsimp only [K₀, cechCochain, cechComplexFunctor,
          toModuleKSheaf, toModuleKPresheaf_obj]
        letI := h_mod_pi₃
        exact e₃.toAddEquiv.module R
      -- =========================================================================
      -- Step 2: repackage the Čech differential as `R`-linear maps.
      -- =========================================================================
      -- The Čech differential is an alternating sum of restriction maps; each
      -- restriction map `Γ(C.left, V) → Γ(C.left, W)` (for `W ≤ V ≤ U`) is an
      -- `R`-algebra homomorphism, hence `R`-linear.
      --
      -- Iter-087 refactor (CORRECTIVE): the deep R-linearity claim is hoisted
      -- to the top-level theorem `cechCofaceMap_pi_smul` (above), specialized
      -- to the project's Čech-cochain context. Its body is currently `sorry`
      -- (active prover target). The call site below produces a term that
      -- definitionally matches the local `R`/`scK₀`/`Z_i`/`e_i`/`h_mod_pi_i`
      -- introduced in this proof, so the downstream
      -- `h_diff_pi_smul_f r (e₁ x)` rewrite in `f_R.map_smul'` type-checks.
      have h_diff_pi_smul_f := cechCofaceMap_pi_smul hU s₀ hn
      -- ITER-076 prover: dropped `h_diff_pi_smul_g` declaration entirely. Its
      -- statement was patterned on `h_diff_pi_smul_f` but the `e₃`-image at
      -- the codomain `scK₀.X₃` no longer type-checks: unlike `scK₀.X₂` (which
      -- reduces to `↑(∏ᶜ Z₂)` because the index `n` is literal), `scK₀.X₃ =
      -- K₀.X ((ComplexShape.up ℕ).next n)` does not reduce to `↑(∏ᶜ Z₃)`
      -- (`Z₃`'s Fin index uses the literal `n + 2`). The next iteration can
      -- re-introduce it after either adding `ComplexShape.up_next` rewrites
      -- to the `e₃`/`Z₃` setup or by casting through `Eq.mpr` on the type
      -- equality. With `g_R.map_smul'` rolled back to `sorry` below, the
      -- declaration is no longer referenced.
      let f_R : scK₀.X₁ →ₗ[R] scK₀.X₂ :=
        { toFun := ⇑(ConcreteCategory.hom scK₀.f)
          map_add' := map_add (ConcreteCategory.hom scK₀.f)
          map_smul' := by
            -- ITER-077: with literal `h_mod_X_i = e_i.toAddEquiv.module R`,
            -- the smul on `scK₀.X_i` is `e_i.symm (r • e_i x)` by `rfl`
            -- (`Equiv.smul_def` is `rfl`). Transport `h_diff_pi_smul_f` via
            -- `e₂.injective` to close.
            -- ITER-080: the iter-079 `change` no longer fires after the
            -- `perI_i` letI-refactor — fresh `r • e_i x` synthesis now picks
            -- a different `Module R (∀ i, Z_i)` instance than `h_mod_X_i`'s
            -- baked-in one. Shadow `h_mod_pi_i` locally so fresh synthesis
            -- prefers `h_mod_pi_i`, matching `h_mod_X_i`'s construction.
            intro r x
            change (ConcreteCategory.hom scK₀.f) (e₁.symm (r • e₁ x)) =
              e₂.symm (r • e₂ ((ConcreteCategory.hom scK₀.f) x))
            apply e₂.injective
            rw [LinearEquiv.apply_symm_apply, h_diff_pi_smul_f r (e₁ x),
              LinearEquiv.symm_apply_apply] }
      let g_R : scK₀.X₂ →ₗ[R] scK₀.X₃ :=
        { toFun := ⇑(ConcreteCategory.hom scK₀.g)
          map_add' := map_add (ConcreteCategory.hom scK₀.g)
          map_smul' := by
            -- ITER-077: blocker for the `f_R`-style transport is the smul on
            -- `↑scK₀.X₃ = ↑(K₀.X ((up ℕ).next n))`. Because `(up ℕ).next n` does
            -- not reduce to `n + 1` by `rfl` (opaque `Classical.choose`), the
            -- `h_mod_X₃` instance is built via `rw [h_eq]; exact e₃.toAddEquiv.module R`,
            -- so the smul carries an `Eq.mpr`-transport through
            -- `CochainComplex.next` that breaks the literal `r • y = e₃.symm
            -- (r • e₃ y)` identity.  The `f_R` pattern (`change` + `e₂.injective`
            -- + `h_diff_pi_smul_f`) does NOT lift to the g-side without first
            -- restating `h_diff_pi_smul_g` with explicit `Eq.mpr`-casts on the
            -- codomain.  Deferred to the next iteration.
            intro r x
            sorry }
      have hf_eq : ⇑f_R = ⇑(ConcreteCategory.hom scK₀.f) := rfl
      have hg_eq : ⇑g_R = ⇑(ConcreteCategory.hom scK₀.g) := rfl
      -- Step 3: for each `f ∈ ↑s₀`, the canonical localization map
      -- `LocalizedModule.mkLinearMap (powers f.1) scK₀.X_i` is universal — this is
      -- the standard Mathlib instance `localizedModuleIsLocalizedModule`. The
      -- substantive iter-069 plan invokes the *slice-cover* identification as the
      -- localization target; the present formulation (using `LocalizedModule`
      -- directly) sidesteps the product-localisation commutation argument and
      -- is closable by typeclass synthesis.
      --
      -- Iter-071 prover: discharge `h_loc_X_i (f : ↑s₀)` for each `i ∈ {1, 2, 3}`
      -- via `localizedModuleIsLocalizedModule` (kernel-only).
      have h_loc_X₁ (f : ↑s₀) : IsLocalizedModule.Away (f.1 : R)
          (LocalizedModule.mkLinearMap (Submonoid.powers (f.1 : R)) scK₀.X₁) :=
        localizedModuleIsLocalizedModule _
      have h_loc_X₂ (f : ↑s₀) : IsLocalizedModule.Away (f.1 : R)
          (LocalizedModule.mkLinearMap (Submonoid.powers (f.1 : R)) scK₀.X₂) :=
        localizedModuleIsLocalizedModule _
      have h_loc_X₃ (f : ↑s₀) : IsLocalizedModule.Away (f.1 : R)
          (LocalizedModule.mkLinearMap (Submonoid.powers (f.1 : R)) scK₀.X₃) :=
        localizedModuleIsLocalizedModule _
      -- Step 4: the localized Čech differential `LocalizedModule.map (powers f.1) f_R`
      -- agrees with the slice-cover Čech differential (viewed as an `R`-linear map)
      -- via the universal property of localization (`IsLocalizedModule.ext` plus
      -- `map_comp`).  Consequently `h_a₀_fun f` yields exactness of the localized
      -- differential at each `f ∈ ↑s₀`.
      have h_loc_exact (f : ↑s₀) : Function.Exact
          ⇑(LocalizedModule.map (Submonoid.powers (f.1 : R)) f_R)
          ⇑(LocalizedModule.map (Submonoid.powers (f.1 : R)) g_R) := sorry
      -- Step 5: apply `exact_of_isLocalized_span` to conclude global exactness of `K₀`.
      rw [← hf_eq, ← hg_eq]
      exact exact_of_localized_span (↑s₀ : Set R) h_top f_R g_R h_loc_exact
    -- ===========================================================================
    -- Close the original goal via the transport `K₀ exact → K exact` + exactness of `K₀`.
    -- ===========================================================================
    exact h_transport h_K₀_exact


end AlgebraicGeometry.Scheme
