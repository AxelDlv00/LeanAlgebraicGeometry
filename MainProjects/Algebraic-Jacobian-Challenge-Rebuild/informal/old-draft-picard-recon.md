# Old-draft Picard-model reconnaissance (read-only extraction)

*2026-07-11. Extracted from `MainProjects/Algebraic-Jacobian-Challenge` (READ-ONLY prior art —
design lessons only, no code copied) plus inbox I-0074/I-0061, to ground the rebuild's Wave-3
spec. Paths abbreviated `AJC/`; line numbers as of the checkout.*

## 1. How the old draft modeled line bundles — and why it burned

**Not cocycles.** Carrier = mathlib sheaf-of-modules object + pointwise invertibility predicate
(`AJC/…/Picard/LineBundlePullback.lean:115-131`):

```lean
def IsLocallyTrivial {X : Scheme.{u}} (M : X.Modules) : Prop :=
  ∀ x : X, ∃ U : X.Opens, x ∈ U ∧ IsAffineOpen U ∧
    Nonempty (M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf)

def OnProduct {S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S) : Type (u+1) :=
  { M : (Limits.pullback πC πT).Modules // IsLocallyTrivial M }
```

Triviality quantifies over affine opens of the product itself (not a pulled-back cover, not a
refinement of T). Consequences proved: `IsLocallyTrivial.pullback` (Stacks 01HH),
finite-presentation lemmas.

**The burn (~15,400 lines, larger than the route-decision's "~10k")**: the sheaf-object model
forces a genuine ⊗, unit, and dual `ℋom(L,𝒪)` at `Scheme.Modules` level; mathlib has no
`MonoidalCategory`/`MonoidalClosed` for a varying structure sheaf. Hand-built substrate:
`TensorObjSubstrate.lean` 4592 + `TensorObjInverse.lean` 3424 + `DualInverse*` ~4300 + internal
hom ~1100 + …. The blocker report `AJC/informal/exists_tensorObj_inverse.md`: "INFRASTRUCTURE
MISSING … blocked at its FIRST step … NO `MonoidalClosed (SheafOfModules R)` … No
object-gluing/descent fallback."

**Post-mortem conclusion (verbatim, blueprint `rem:scheme_modules_monoidal_off_path`)**: a full
monoidal structure "is explicitly off-path and not pursued … the group law never consumes a
coherent monoidal category … every group axiom is a proposition of the form `Nonempty(⋯ ≅ ⋯)`
… the group is assembled by hand from the existence-of-isomorphism facts." The one corner that
DID use transition-unit cocycles on a pinned 2-cover (`Pic0DualNumberCocycle.lean`, tangent
space) went smoothly. Sharpest datum for the rebuild: cocycles worked, sheaf-objects burned.

## 2. The relative functor of record

Two carriers; the honest one is the H_T-coset relation (`RelPicFunctor.lean:512-516`):

```lean
def relPicRel … (L L' : LineBundle.OnProduct πC πT) : Prop :=
  ∃ (N : T.Modules) (hN : LineBundle.IsLocallyTrivial N),
    Nonempty (L.carrier ≅ Modules.tensorObj (pullbackAlongProjection πC πT N hN).carrier L'.carrier)
```

bundled as `relPresheaf : (Over (Spec (.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u+1}` (test category = ALL
k-schemes; group law `[L]+[L'] := [L⊗L']` by hand from coherence-iso existence);
`picSharp := relPresheaf ⋙ forget` (`FGAPicRepresentability.lean:173-177`).

**FALSE-axiom trap (I-0061, certified)**: the absolute iso-class functor `Pic(C ×ₖ T)` differs
from `Hom(T, Pic)` by `Pic(T)`; wiring representability to it is disprovable. Always the
relative quotient.

**Rigidification, not étale sheafification**: that mathlib had NO étale topology at all (the
rebuild's v4.31 HAS the topologies, still no big-site sheafification functor).
`FGAPicRepresentability.lean:39-59`: use Kleiman §2 **Thm 2.5** — when `f` has a section and
`𝒪_S = f_*𝒪_X` universally, `Pic_{X/S}(T) → Pic_{(X/S)ét}(T) → Pic_{(X/S)fppf}(T)` are all
bijective — so under `[HasRationalPoint C]` the PLAIN relative functor is representable.
Implemented via `RigidifiedPic.lean`: `Rigidification σ L`, `exists_rigidification_relPicRel`
(Kleiman `lm:fff`), automorphism-freeness (`lm:aut`) ⇒ Zariski-sheaf.

## 3. Degree and Pic⁰

- `Pic0Scheme C := GroupScheme.IdentityComponent (PicScheme C)`; the §1 identity-component
  substrate is **sorry-free** (open subgroup scheme, geometrically connected, baseChangeIso,
  Pic0.grpObj).
- `PicScheme.degree` (`IdentityComponent.lean:1455-1460`) stayed a bare `sorry` the whole
  campaign — blocked on Hilbert-polynomial machinery that never landed. What DID land:
  divisor-side `DivFamily.fiberDeg` (colength of `𝒪_D`); campaign milestone B4 (`picSharpDeg`,
  degree via finite-flat pushforward rank) was the planned repin and never happened.
  **Lesson: define degree via pushforward rank, never via Hilbert polynomials.**

## 4. How far representability got

Keystone `instHasPicScheme [HasRationalPoint C] : HasPicScheme C := ⟨sorry⟩` — the single real
sorry of the FGA file; everything downstream (PicScheme, GrpObj via `GrpObj.ofRepresentableBy`,
lft, separated) is proved-by-extraction but sorryAx-tainted. Note the class stores
`Nonempty (RepresentableBy …)` — the rebuild must store the **datum** instead (route rule 4).

The judged campaign map is `AJC/informal/pic-representability-campaign.md` (524 lines, ~30
milestones, D3 Milne–Kollár architecture scored 8.5 over Kleiman-faithful 6.0 and
curve-specialization 7.5). Clusters: P (curve cohomology kit: h⁰/h¹/χ over all field
extensions, RR χ-ledger, uniform H¹ vanishing ∃-form), B (base-change engines: B3 rigid
pushforward — hardest single lemma; B4 degree; B6 separatedness device), A (degree-translation,
Abel map), D′ (Div^d representability via Grassmannian comparison + locally-closed carving),
J (Milne §4 over separably closed: Σ-opens, J^Σ equalizer, gluing of Pic^r), G (Galois
descent: Speiser semilinear descent G2b + finite Galois quotient engine G2 — both landed
clean and reusable; G3-G5 assembly never landed). Critical path
`P→{P5 ∥ B3}→D′→J→G`. **Quot-scheme lane explicitly off-route** (~12k lines, 30+ sorries in
the old tree; its only Kleiman consumer `lm:qt` bypassed by curve-specific Div^d geometry).
Audited correction from B3: "finite FREE K⁰ is FALSE globally — projective is what's needed."

## 5. Tangent space T₀Pic = H¹ (the working route)

Set-level chain PROVED end-to-end in the old draft:
`Dual_{κ(e)}(m_e/m_e²) ≃ T₀Pic⁰ ≃ T₀Pic ≃ ker(Pic^♯(Spec k[ε]) →+ Pic^♯(Spec k))`
(open-immersion transport uses `Subsingleton (PrimeSpectrum k[ε])`). Reduction of the keystone
to ONE scalar identity `dim_{κ(e)} m_e/m_e² = dim_k H¹(C,𝒪_C)` via
`Module.nonempty_addEquiv_of_finrank_eq_of_ringEquiv`. Landed algebra: truncated-exponential
unit split `(R[ε])ˣ ≃* Rˣ × (R,+)`; the two-chart Čech unit-cocycle kernel equiv
`Γ(U₁⊓U₂)/(Γ(U₁)+Γ(U₂)) ≃+ ker(Ȟ¹ˣ(B[ε])→Ȟ¹ˣ(B))`; `H¹ ≃ H1Cok` on any 2-affine cover.
Remaining leaves when the campaign stopped: (1) the geometric cocycle substrate — invertible
sheaf on `C ×ₖ Spec k[ε]` trivial along `ε↦0` is trivial on the two base-changed charts +
`Γ(V × Spec k[ε]) ≅ Γ(V)[ε]`; (2) κ(e) ≃ k semilinearity bookkeeping.
**Hazard (campaign W12)**: a bare `Equiv` does not determine `finrank` over an infinite field —
carry κ(e)-(semi)linear structure or explicit finrank chains. Also a poisoned-inheritance
catch: a file marked "proved" that never compiled — kernel-verify every closure.

## Binding lessons for the rebuild's Wave-3 spec

1. **Cocycle/transition-data model, never `Scheme.Modules` + `IsLocallyTrivial`.** On
   transition units, ⊗ = multiplication and inverse = unit-inversion; the 15k-line substrate
   evaporates. (Note the model must allow refinements in the C-direction too — a line bundle
   need not trivialize on the pinned 2-cover, e.g. Pic of an affine Dedekind chart ≠ 0. The
   honest definitional carrier is Čech-style: covers + unit cocycles mod coboundaries +
   refinement, i.e. `Pic := Ȟ¹(𝒪ˣ)` made definitional; mathlib's
   `NonabelianCohomology.H1` supplies the fixed-family layer.)
2. **No monoidal sheaf categories, ever** (confirmed wall, no escape hatch).
3. **Relative H_T-coset functor on `(Over (Spec k))ᵒᵖ`, group-valued; NEVER the absolute
   `Pic(C×T)` carrier** (certified false-axiom trap).
4. **Representability route without a rational point**: rigidify where a point exists (Kleiman
   2.5 route, honest `HasRationalPoint` there), get the scheme over a finite separable `k'`
   (a smooth geometrically integral variety has a closed point with separable residue field),
   then Galois-descend the scheme and the `RepresentableBy` datum to `k` (Speiser + G2 quotient
   engine, both re-derivable — they landed clean). The étale-sheafified functor is the pin
   target; its concrete hand-rolled definition (covers + descent classes, or Kleiman-2.5
   comparison bijections where a section exists) is a rebuild design decision — do NOT wait
   for abstract big-site sheafification (doesn't exist in v4.31).
5. **Gate = structure carrying the `RepresentableBy` DATUM** (`JacobianData C`), never
   `Nonempty` + choice, never a sorried instance (poisons everything downstream with sorryAx).
6. **Degree via finite-flat pushforward rank** (B4 shape), Pic⁰ = ker(degree); identity-
   component substrate is re-derivable and was sorry-free.
7. **T₀ route**: reduce to the dimension count, run the truncated-exponential 2-chart cocycle
   engine; budget the `Γ(V×Spec k[ε]) ≅ Γ(V)[ε]` substrate and κ(e)≃k semilinearity; carry
   linear structure through every equiv (finrank hazard).
8. **Kernel-verify every claimed closure** (the old draft had a file falsely marked proved).
