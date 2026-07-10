# Route decision — the mathematical architecture of the rebuild

*2026-07-11, Fable-5 design session. Inputs: a 5-agent survey (mathlib v4.31.0 capability
inventory; old-draft map; Kleiman/FGA route DAG; alternative-routes survey; operational
lessons). Survey reports are archived in the session scratchpad; their load-bearing
conclusions are restated here so this document is self-contained.*

This document fixes the route for all 14 protected targets in
`AlgebraicJacobian/Challenge.lean` and the design rules every wave must follow.
It is the map; the blueprint is the mathematics; the Lean tree is the proof.

## 1. The route in one paragraph

**`Jacobian C := Pic⁰_{C/k}`**, the identity component of the scheme representing the
étale-sheafified relative Picard functor of `C/k` (Kleiman, *The Picard Scheme*, FGA
Explained ch. 5). Representability is the central mountain (Grothendieck's Thm 4.8,
specialized hard to a smooth proper geometrically irreducible curve over a field).
The Albanese universal property is proved Milne-style (*Abelian Varieties* III.6.1):
symmetric powers `C^(g) → J` birational, rational maps into abelian varieties extend
(Milne I.3.2 = I.3.1 + Lemma 3.3), rigidity makes the factorization a homomorphism,
uniqueness descends from `k̄` to `k`. The genus is `g(C) := dim_k H¹(C, 𝒪_C)` with
`H¹` the derived-functor cohomology of the Zariski site of `C` valued in `ModuleCat k`,
computed by a pinned 2-affine-cover Mayer–Vietoris cokernel and proved finite by the
two-lattice ladder over a finite map `C → ℙ¹`. Every functorial target (`functor`,
`baseChangeIso`, the coherences) is a uniqueness-of-representing-object corollary of a
single pinned `RepresentableBy` datum — never a `Classical.choice` extraction.

Why not the alternatives (survey verdicts):

- **Weil group-chunk construction (Sym^g + birational group law): rejected.** Its
  obligations (scheme quotients by finite groups, relative divisors,
  cohomology-and-base-change, Weil's globalization theorem, plus a descent problem for
  pointless curves — the challenge's `Jacobian` takes **no rational point**) meet or
  exceed the FGA debt, and the functorial targets would still have to be re-derived
  through the Pic functor afterwards (Milne III.7.6). FGA's Thm 4.8 needs no point;
  that is a structural advantage for this exact statement file.
- **Kleiman's own Albanese derivation (`rmk:Alb`): rejected** — it outsources dual
  abelian varieties, autoduality (`Ĵ ≅ J`, [EGK Thm 2.1], unproved in our references)
  and projectivity of abelian varieties. Milne III.6.1 is strictly lighter and its
  ingredients (Sym^g, Riemann–Roch) are shared with the `Div^d`-representability leg,
  so their cost is amortized.

## 2. Ground truth about mathlib v4.31.0 (verified in the checkout, not from memory)

**Gifts to design around** (all present):

- Group objects: `GrpObj`, bundled `Grp C`, `Functor.mapGrp/mapGrpIdIso/mapGrpCompIso/
  mapGrpNatIso` — the challenge's vocabulary, complete. **`GrpObj.ofRepresentableBy`**:
  a representing object of a group-valued functor gets `GrpObj` for free.
- `AlgebraicGeometry/Group/Abelian.lean`: `isCommMonObj_of_isProper_of_geometricallyIntegral`
  (proper geometrically integral group scheme over a field is commutative) — the
  rigidity *corollary* is already a theorem.
- `AlgebraicGeometry/Group/Smooth.lean`: `smooth_of_grpObj` (geometrically reduced +
  locally finite type group scheme over a field ⇒ smooth) — kills the deformation-theory
  half of smoothness; what remains of `smoothOfRelativeDimension_genus` is
  `T₀J ≅ H¹(C,𝒪_C)` plus dimension bookkeeping.
- `Sites/Representability.lean` (Zariski sheaf glued from representable opens is
  representable, Stacks 01JJ), `subcanonical_zariskiTopology`, the étale/fppf/fpqc sites.
- `ZariskisMainTheorem.lean`: `IsFinite.of_isProper_of_locallyQuasiFinite` — the
  finite-map-to-ℙ¹ leg shrinks.
- Sheaf cohomology `Sheaf.H` via `Ext` + Grothendieck-abelian `HasExt`/`EnoughInjectives`
  + the Mayer–Vietoris LES (`Sites/SheafCohomology/`) — at `AddCommGrpCat`; the
  `ModuleCat k` twin is ours to build (de-risked: the old draft did it).
- `IsProper`/`SmoothOfRelativeDimension`/`Geometrically*` with exactly the stability
  instances the frozen file consumes; valuative criterion over arbitrary valuation rings;
  `Proj` + its properness; function fields; Dedekind/`HeightOneSpectrum` valuation stack;
  `RingTheory/Invariant` (`A^G`); rational maps (`Birational/RationalMap.lean` — no
  extension theorems though).

**Load-bearing absences** (each is ours to build; nothing above Layer A of the DAG exists):
coherent cohomology of schemes (any `H^i(X,F)`, `R^i f_*`, base change, finiteness,
vanishing); line bundles / `Pic` of a scheme; Weil/Cartier divisors, degrees, `L(D)`;
Riemann–Roch / Serre duality in any form; ampleness / projectivity vocabulary / `𝒪(d)` /
Serre finiteness; Hilbert/Quot/Grassmannian schemes; quotients of schemes (finite groups
or equivalence relations); symmetric powers; relative effective divisors; rigidity;
rational-map extension theorems; smooth ⇒ geometrically reduced; Auslander–Buchsbaum;
DVR refinement of the valuative criterion; genus (zero hits in all of Mathlib).

## 3. Definitions of record (the semantic pins)

- **genus**: `genus C := Module.finrank k (H¹ₖ(C, 𝒪_C))` where `Hⁿₖ(C, F)` is the
  Ext-based cohomology of the (essentially small) Zariski site of `C` with values in
  `ModuleCat k`, applied to the structure sheaf viewed as a sheaf of `k`-modules.
  *Not* a Čech-carrier definition: the derived definition is canonical
  (cover-independent by construction), mathlib-idiomatic, and the MV (0,1)-slice
  gives the 2-cover cokernel computation as a theorem, gate-free (old draft proved
  this bridge end to end; we re-derive it).
- **Jacobian**: the representing object of the degree-0 part of the étale-sheafified
  relative Picard functor, carried as a **pinned `RepresentableBy` datum** (data, not
  `Nonempty`), from which `instGrpObj` is `GrpObj.ofRepresentableBy`, `functor.map` is
  precomposition of represented functors, and `baseChangeIso` + coherences are
  uniqueness-of-representing-object arguments.
- **ofCurve**: the Abel–Jacobi map `t ↦ [𝒪(Γ_t − P_T)]` via graph divisors
  (`Div¹_{C/k} = C`), landing in `Pic⁰` because `C` is connected and `P ↦ 0`.
- **Albanese UP**: Milne III.6.1 over `k̄`, descended to `k` uniqueness-first
  (Milne 6.4-pattern). Note the challenge asks uniqueness among **plain** `Over`-morphisms;
  rigidity converts any competitor into a homomorphism (it is pointed:
  `η ≫ g = P ≫ ofCurve P ≫ g = P ≫ f = η`), and homomorphisms agreeing on the
  generating curve agree.

## 4. Proof-obligation DAG (cost-ordered waves)

Difficulty: [R] routine, [S] substantial, [RG] research-grade-for-mathlib.
The four [RG] clusters are: representability (B4), Albanese (N12), properness (N5),
and the coherent-cohomology substrate they stand on. Everything else is [R]/[S] given
its predecessors.

### Wave 1 — curve substrate + the genus lane (fully de-risked; do first)
1. `Curve/Basic` [R–S]: standing consequences of the hypothesis bundle — integral,
   quasi-compact, separated; `Γ(C,𝒪_C) ≅ k` (via mathlib's
   `isIso_pushoutSection_of_isQuasiSeparated_of_flat_right` + properness `isField`
   facts); function field; stalk dimension ≤ 1 on standard-smooth rel-dim-1 charts.
2. `Curve/GeometricallyReduced` [S]: **smooth ⇒ geometrically reduced** (fibers of a
   smooth morphism are geometrically regular). Mathlib gap under EVERY target: the
   frozen file says `GeometricallyIrreducible`; all the real mathematics needs
   `GeometricallyIntegral`. Settled here once, as an instance.
3. `Cohomology/*` [S]: `ModuleCat k`-valued sheaf cohomology `Hⁿₖ` (Grothendieck-abelian
   ⇒ `HasExt`, universe discipline fixed once); degree-1 vanishing on affines;
   2-affine-cover MV square + `H1Cok` cokernel carrier; the MV (0,1)-slice bridge
   `H¹ₖ(C,𝒪) ≃ₗ[k] H1Cok`.
4. `Curve/MapToP1` [S]: a nonconstant rational function spreads out to a finite
   `π : C → ℙ¹` (ZMT does the heavy lifting now).
5. `Cohomology/Finiteness` + `Genus` [S]: two-lattice ladder ⇒ `Module.Finite k H¹ₖ`;
   **define `genus`, discharge the first protected sorry.**

### Wave 2 — abelian-variety generalities (parallel to late W1)
6. `AbelianVariety/Rigidity` [S]: Mumford Form-I rigidity over `k̄`; Milne I Cor 1.2
   (pointed map of AVs is a homomorphism), Cor 1.5. (Old draft proved this 908-line
   design; re-derive compactly, checking what `Group/Abelian.lean` already covers.)
7. χ-ledger / RR-lite [S]: `h⁰/h¹/χ` for line-bundle-twisted sheaves on `C` via the
   2-cover carrier; `χ(𝒪) = 1 − g`; degree via `deg L := χ(L) − χ(𝒪)`; Riemann
   inequality; principal divisors have degree 0. Feeds N2 (projectivity), Div^d, and
   the Albanese birationality. Serre duality is deferred until a consumer forces it
   (function-field route via Weil differentials if ever needed — never scheme-theoretic).

### Wave 3 — the Picard functor and the gated spine
8. `Picard/LineBundles` [S]: invertible 𝒪-modules on `C ×ₖ T` *modeled by transition
   data on the pinned 2-cover after affine-local refinement of `T`* — no monoidal
   structure on sheaf categories, ever (the old draft burned ~10k lines there; its own
   post-mortem endorses the cocycle model).
9. `Picard/Functor` [S]: the rigidified/étale-sheafified `Pic_{C/k}` on affine test
   schemes; group-valued; degree map; `Pic⁰` sub-functor.
10. `Picard/Witness` [R]: the **`JacobianData C` structure** — representing object +
    pinned `RepresentableBy` + the instance package. Downstream waves consume
    `(d : JacobianData C)` as a section variable. NEVER a sorried instance
    (typed-sorry data poisons every consumer with `sorryAx`); NEVER `Nonempty` + choice
    (destroys the naturality data that `functor`/`baseChangeIso` need).

### Wave 4 — representability [RG mountain #1]
11. Rigid pushforward engine (Mumford AV II.5 two-term projective replacement;
    `h¹`-vanishing ⇒ `q_*L` locally free of rank χ commuting with base change).
12. Uniform `h¹`-vanishing for large degree; `Div^d` for curves; Grassmannian/ℙ-bundle
    embedding; Σ-opens, equalizer, gluing over `k^s` (Stacks 01JJ); Galois descent to `k`
    (Speiser semilinear descent — landed cleanly in the old draft, re-derive).
    The old draft's judged D3 campaign decomposition (~15–20 milestones) is the map;
    Quot schemes / flattening / Altman–Kleiman are **off-route** (their only Kleiman
    consumer, `lm:qt`, is bypassed by the curve-specific `Div^d` geometry).

### Wave 5 — the abelian-variety package for `Pic⁰` [RG mountains #2, #3]
13. Tangent space `T₀Pic = H¹(C,𝒪)` (dual numbers, truncated exponential) [S];
    smoothness via geometric reducedness at 0 + `smooth_of_grpObj` [S];
    `SmoothOfRelativeDimension (genus C)` assembly [S].
14. Properness [RG]: valuative criterion; extend a line bundle on `C_K` over `C_A`
    (`C_A` regular 2-dimensional ⇒ locally factorial — needs an Auslander–Buchsbaum-grade
    brick; budget explicitly, consider the `C^(g)`-surjection alternative if Sym^g lands
    first for Albanese).
15. Geometric irreducibility: identity-component theory (`lem:agps(3)`: `G⁰` open-closed,
    finite type, geometrically irreducible, formation commutes with field extension) [S].
    This single lemma also powers `baseChangeIso`.

### Wave 6 — Albanese [RG mountain #2]
16. Sym^r C as a scheme (finite-group quotient via Γ-stable affine covers — the old
    draft's Galois-quotient engine design, re-derived) [S–RG]; smoothness of `C^(g)` [S];
    `Div^r ≅ C^(r)` [S] (shared with Wave 4!).
17. Rational-map extension chain: Milne I.3.1 [S], Lemma 3.3 (the four audited substeps;
    two were proved in the old draft) [RG], Thm 3.2 [R given both].
18. Milne III.6.1 assembly over `k̄` [S]; uniqueness-first Galois descent to `k` [S];
    `ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp` discharge.

### Wave 7 — the functorial layer (cheap **by design** if Wave 3's pin is respected)
19. `functor` (pullback of line bundles = precomposition on represented functors;
    laws by uniqueness) [S-tedious]; 20. `baseChangeIso` (étale-site base-change formal
    identity + `(Pic⁰)_L = (Pic_L)⁰` from #15) [S]; 21. coherences + `baseChange_ofCurve`
    (uniqueness of isos intertwining pinned universal elements) [R–S given the pin].

## 5. Design rules (binding for every wave; distilled from the campaign post-mortems)

1. **Keystone funnel.** Every wave funnels to one keystone with a wide parallel base;
   state the *narrowest* form a consumer needs (degree-1-only vanishing beat the full
   Čech-to-derived comparison; i=0 affine base-change bricks beat the `R^i f_*` engine).
2. **Statement audit before proof.** Every pinned statement gets a semantic audit against
   the source before anyone proves it (the old campaign shipped three false-as-pinned
   statements; each cost runs). Counterexamples for rejected pins go in the blueprint.
3. **No sorried data, no choice-extracted witnesses.** Deep pillars are gated as Prop
   classes or explicit structure hypotheses; `sorry` never inhabits a def/instance.
4. **One pinned universal element.** `Jacobian`, `functor`, `baseChangeIso` are all
   defined through the same `RepresentableBy` datum; coherences become uniqueness.
5. **No monoidal sheaf categories; no global adele space; no general `R^i f_*` engine;
   no Quot schemes.** Each is a measured multi-week detour whose consumers have
   cheaper curve-specific substitutes.
6. **Files ≤ 500 lines; mathlib naming; blueprint chapter per Lean directory,
   1-to-1 nodes, `\leanok` only after kernel check; `\source{}` only after reading.**
7. **Verification bar**: `lake build <Module>` (kernel), then `lean_verify` axiom audit
   (`propext, Classical.choice, Quot.sound` only). LSP is advisory; `lake env lean`
   is a false oracle (lakefile sets `maxSynthPendingDepth = 3`).
8. **Uniform genus.** No genus-0 fork anywhere; `J = Pic⁰` uniformly (the old draft
   deleted a weeks-long genus-0 lane).
9. **Known Lean walls + fixes** (from the ops mining, use as first resort):
   `Over.pullback` instance-opacity → point-level `congrArg` calc chains; defeq-blocked
   `𝟙` → `erw [Category.comp_id]`; functor laws by `subst`-shaped proofs; scoped
   `maxHeartbeats` bumps ≤ 1M (never stack past it — restructure); repeated `binop%`
   products hoisted into a named def; `GrpObj` is data → `letI`; `open scoped MonObj`.

## 6. What "done" means, phase by phase

- **Phase 1**: all 14 protected declarations sorry-free; `lake build` green;
  `#print axioms` on each = standard three; blueprint every node `\leanok` with sources.
- **Phase 2** (only after green): REVIEW.md anchors for the three headline theorems,
  code↔paper correspondence tightening, `ForMathlib/` extraction of the general bricks
  (smooth⇒geometrically reduced, identity-component theory, rigidity, MV `ModuleCat k`
  slice, finite-group quotients, Speiser descent are the obvious PR candidates).
