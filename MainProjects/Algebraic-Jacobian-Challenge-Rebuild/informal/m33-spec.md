# m33 spec — Milne Lemma 3.3 (AJCR.w6-albanese.m33, prover lane w6-m33, 2026-07-17)

*Discharges the D2 hypothesis of `informal/w6-port-worksheet.md`: prove
`Milne33Indeterminacy f` (Prop-valued def, landed 79083007e in
`Albanese/CodimOneIndeterminacy.lean`) for a rational map `f : X ⇢ G` over `k̄`
from a smooth geometrically-irreducible variety to a group variety.
Source: Milne, *Abelian Varieties*, Ch. I §3 Lemma 3.3, printed pp. 17–18
(PDF pp. 23–24, read via vision this session; transcriptions
`abelian-varieties:page-0023`, `page-0024` landed per I-0176; the old draft's
proof-plan prose: old-tree `Albanese/CodimOneExtension.lean` §5 ~L1692 and
`Algebraic-Jacobian-Challenge/informal/milne-lemma-3.3.md`).*

**Audited entry state.** Substeps 1, 2-easy, 4a, 4b-wrapper CLOSED (landed:
DifferenceMap, Milne33Substeps, PolePurity/-Local, RationalMap{Precomp,Prod,FunctionField},
CodimOne{Indeterminacy,StalkRegularity,SmoothReduced,DVRStalk,Matsumura}).
OPEN: substep 2-hard, substep 3, final assembly. This spec re-derives the
missing pieces against the *pinned* mathlib (v4.31.0) and locks the route.

## §0 Two audit findings that reshape the old plan (decisions D1, D2)

- **D1 (no UFD, no fppf descent — both routes of the old plan are dead and
  unnecessary).** The pin has NO Auslander–Buchsbaum UFD theorem
  (`RingTheory/RegularLocalRing/` = Defs only), so Milne's implicit
  "coprime local equation of `div(f)_∞`" is unavailable (and reg-local⇒UFD is a
  rejected mountain, cf. w5-worksheet D3). The old 2-hard plan's
  "smooth-descent reflection `Dom(f∘pr₁) ⊆ pr₁⁻¹(Dom f)`" (fppf descent,
  flagged NOT-one-session in milne-lemma-3.3.md) is likewise *avoided
  entirely*: see D3/D5.
- **D2 (the one genuinely new algebra kernel is CM equidimensionality).**
  Every workable variant of Milne's "AG 9.2" diagonal-intersection step
  reduces to: *(K) in a Cohen–Macaulay local ring, `ht p + dim R/p = dim R`
  for every prime `p`* — used ONCE, at the stalk `𝒪_{Y,z̃}` (regular ⟸ landed
  `isRegularLocalRing_stalk_of_smooth`; CM ⟸ landed project instance
  `CohenMacaulay.of_regular`), for the height-1 prime of the 4a pole point.
  All prerequisites for (K) are IN THE PIN or landed:
  prime filtration + induction principle
  (`IsNoetherianRing.exists_relSeries_isQuotientEquivQuotientPrime`,
  `…induction_on_isQuotientEquivQuotientPrime`), `associatedPrimes.finite`,
  `biUnion_associatedPrimes_eq_zero_divisors`,
  `minimalPrimes_annihilator_subset_associatedPrimes`, Krull height theorem
  (`Ideal.height_le_spanRank_toENat_of_mem_minimalPrimes` + card variants),
  NZD/regular-sequence dimension identities
  (`RingTheory/KrullDimension/{NonZeroDivisors,Regular}.lean`:
  `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim`,
  `ringKrullDim_le_ringKrullDim_add_card`,
  `ringKrullDim_add_length_eq_ringKrullDim_of_isRegular`), project depth
  package (`Module.depth`, `depth_eq_smallest_ext_index`,
  `depth_of_short_exact`, `CohenMacaulay` class). The missing link inside (K)
  is Ischebeck's bound `p ∈ Ass R ⟹ depth R ≤ dim R/p` (Ext-vanishing
  dévissage over the pin's prime-filtration induction). This is the [RG]
  mountain of the lane; it is bounded and self-contained.

## §1 The route (decisions D3–D7)

Fix `X, G : Over (Spec k̄)` with the CodimOneExtension-layer instance pack
(X: Smooth, GeometricallyIrreducible, IsSeparated, LocallyOfFiniteType,
IsIntegral, IsReduced; G: same + GrpObj), `f : X.left ⇢ G.left`,
`hover : f.compHom G.hom = X.hom.toRationalMap`. Write `Y := pullback X.hom
X.hom` (integral ⟸ landed `isIntegral_pullback_self`; all stalks regular ⟸
landed `isRegularLocalRing_stalk_of_smooth` through Smooth-stability
instances), `Φ := differenceRationalMap f hover`, `Φ₀ := Φ.toPartialMap`,
`δ : X.left ⟶ Y := pullback.lift 𝟙 𝟙 rfl`, `e ∈ G.left` the image of the unit
point `ε : Spec k̄ ⟶ G.left`.

- **D3 (2-hard only at closed rational points; row-section, no descent).**
  The assembly needs 2-hard only at *closed* `x₀` with `κ(x₀) = k̄` (see D6).
  There the old topological blocker dissolves: the row through `x₀` is the
  honest morphism `τ_{x₀} := pullback.lift (X.hom ≫ pt_{x₀}) 𝟙` (fibre
  `pr₁⁻¹{x₀}` parameterized by `X` itself), `pt_{x₀} :=` the `k̄`-point at
  `x₀` (pin: `AlgebraicGeometry/AlgClosed/Basic.lean`, `pointOfClosedPoint`).
  Statement (file `Albanese/Milne33Diagonal.lean`):

  `theorem mem_domain_of_diagonal_mem_domain (x₀ closed rational)
     (hδ : δ.base x₀ ∈ Φ.domain) : x₀ ∈ f.domain`

  Proof: (i) `A := τ_{x₀}⁻¹ᵁ Φ₀.domain` is open ∋ `x₀` (τ(x₀) = δ(x₀) by
  point-lift uniqueness `τ∘pt = pullback.lift(pt,pt) = δ∘pt`); `A ⊓ f.domain`
  nonempty open in irreducible `X` contains a closed rational point `u`
  (Jacobson density + landed Zariski rationality; pin `AlgClosed` +
  `LocallyOfFiniteType`). (ii) With `σ_u := pullback.lift 𝟙 (X.hom ≫ pt_u)`
  (row with second coordinate `u`; `σ_u(x₀) = τ_{x₀}(u) ∈ Φ₀.domain`), set
  `c := (V₁ → Spec k̄) ≫ pt_u-into-Domf₀ ≫ f₀.hom` (the constant `f(u)`) and

  `ψ : PartialMap, domain V₁ := σ_u⁻¹ᵁ Φ₀.domain ∋ x₀,
     hom := pullback.lift (σ_u| ≫ Φ₀.hom) c _ ≫ grpObjMulLeft G`.

  (iii) `ψ.toRationalMap = f`: on the dense open `W := f.domain ⊓ V₁`,
  `Φ₀∘σ_u| = lift(f₀|, c|) ≫ grpObjDiffLeft` (representative agreement of
  `Φ₀` with the landed explicit representative
  `precompDiffPairing ≫ diff` on `Ω := pr₁⁻¹Domf ⊓ pr₂⁻¹Domf`, upgraded from
  dense-open agreement to agreement on all of `Ω ⊓ Φ₀.domain` by
  `ext_of_isDominant_of_isSeparated` [pin]; then `pullback.lift` diagram
  algebra, `σ_u⁻¹(Ω) = f.domain`), and then the landed scheme-level group
  identity `pullback_lift_diff_lift_mul` collapses
  `lift(lift(f₀,c)≫diff, c)≫μ = f₀`. Hence `x₀ ∈ V₁ ≤ f.domain` via
  `RationalMap.mem_domain`. The landed fibre lemma
  (`exists_snd_mem_of_fst_eq_of_mem`) is NOT needed in this closed-point form.
  Also in this file: **diagonal triviality** `Φ₀ ∘ δ| = const e` on
  `δ⁻¹ᵁΦ₀.domain` (hom-group `div_self` + `ext_of_isDominant…`), giving
  `Φ₀(δ(ζ)) = e` pointwise for every `ζ` with `δ(ζ) ∈ Φ₀.domain`, and
  `e ∈ closure {Φ₀(η_Y)}` (continuity at `η_Δ = δ(η_X) ∈ Dom Φ` ⟸ 2-easy).

- **D4 (substep 3 = germ-anchored spreading criterion; no dominance, no
  corestriction to the image-closure subgroup).** The pullback is anchored
  germ-level: `Λ : Γ(V) →germ_e→ 𝒪_{G,e} →stalkSpecializes(γ⤳e)→ 𝒪_{G,γ}
  →Φ₀.stalkMap η→ K(Y)`, where `γ := Φ₀(η_Y)` and `e ∈ closure{γ}` (D3). The
  old plan's dominance caveat is void. File `Albanese/Milne33Pullback.lean`:

  `theorem mem_domain_of_forall_stalk_range (V affine ∋ e)
     (H : ∀ s : Γ(V), Λ s ∈ range (𝒪_{Y,P} → K(Y))) : P ∈ Φ.domain`

  Proof (spreading): `S := Γ(V)` is a f.g. (hence f.p., Noetherian base)
  `k̄`-algebra; `α : S → 𝒪_{Y,P}` the corestriction of `Λ` (injectivity of
  `𝒪_P → K(Y)` on integral `Y`); present `S = k̄[X₁..X_m]/(r₁..r_t)`, lift the
  generator germs to sections on a common open `U'' ∋ P`, kill the finitely
  many relations on a shrink (germ-agreement API), obtain `β : S → Γ(U'')`,
  hence `ψ : U'' ⟶ Spec S ≅ V ⊆ G` (Γ–Spec adjunction + `IsAffineOpen.fromSpec`).
  `ψ` represents `Φ`: both `ψ` and `Φ₀` induce the same `Γ(V) → Γ(O')`
  (`O' := U'' ⊓ Φ₀⁻¹V-open ∋ η`) after the injective `Γ(O') → K(Y)`
  (`Scheme.stalkMap_germ` naturality + `germ_stalkSpecializes`), and morphisms
  into affines are determined by their Γ-maps. Hence `P ∈ Dom Φ`.
  Corollary (assembly-facing contrapositive):

  `P ∉ Φ.domain ⟹ ∃ s, h := Λ s ∉ range (𝒪_{Y,P} → K(Y))`.

  **3-easy** (same file): for `Q ∈ Φ₀.domain` with `Φ₀(Q) = e`:
  `Λ s ∈ range (𝒪_{Y,Q} → K(Y))` — one `stalkSpecializes_stalkMap` naturality
  square (pin, `Geometry/RingedSpace/Stalks.lean`) + `germ` compatibilities.

- **D5 (4b-transport: diagonal regular sequence + Krull + (K); no local
  equation of the pole divisor).** File `Albanese/Milne33Transport.lean`.
  Given `x₀` closed rational ∈ Z(f), `P := δ(x₀)`, `h ∉ range(𝒪_{Y,P}→K(Y))`
  (D4), landed 4a (`Scheme.exists_specializes_coheight_eq_one_of_notMem_stalk_range`)
  gives a pole `w ⤳ P`, `coheight_Y w = 1`.
  - (a) **Diagonal prime is a regular-sequence prime at the closed point**:
    `D := ker(δ*_P : 𝒪_{Y,P} ↠ 𝒪_{X,x₀})` (closed immersion: `IsSeparated
    X.hom` ⟹ `IsClosedImmersion δ` via `pullback.diagonal`; stalk surjectivity
    is part of `IsClosedImmersion`). Both stalks regular with residue `k̄`
    (landed); cotangent count `dim_κ ker(𝔪_P/𝔪² ↠ 𝔪_{x₀}/𝔪²) = dim 𝒪_{Y,P} −
    dim 𝒪_{X,x₀} =: m`; lift a basis to `x₁..x_m ∈ D`, linearly independent
    in `𝔪_P/𝔪²` ⟹ regular sequence (landed
    `matsumura_isRegular_of_linearIndependent_cotangent`) ⟹
    `O' := 𝒪_{Y,P}/(x₁..x_m)` has `dim = dim 𝒪_{Y,P} − m` (pin) and cotangent
    dim `= dim` ⟹ `O'` regular ⟹ domain (landed `isDomain_of_regularLocal`);
    `O' ↠ 𝒪_{X,x₀}` of equal dimension between domains forces kernel `⊥`
    (a prime with coheight = dim in a local domain is ⊥) ⟹ `D = (x₁..x_m)`.
  - (b) **Intersection point**: `q ∈ minimalPrimes (D + J_w) ≤ 𝔪_P`
    (`Ideal.exists_minimalPrimes_le`), `z̃ ∈ Y` its point (chart plumbing as
    in landed PolePurity: `IsAffineOpen.primeIdealOf/fromSpec/isLocalization_stalk`),
    `z̃ = δ(z)` for `z ∈ X`, `z ⤳ x₀` (`q ⊇ D`, quotient prime = point of `X`
    through the affine image chart; `δ|` on affines is `Spec` of the section
    surjection). `w ⤳ z̃` (`q ⊇ J_w`) ⟹ `h ∉ range(𝒪_{Y,z̃} → K(Y))` (landed
    `range_algebraMap_stalk_le_of_specializes`).
  - (c) **Codimension count at `z̃`** (all in `B' := 𝒪_{Y,z̃}`, regular ⟸
    landed, CM ⟸ project instance): `J' := J_w B'` prime of height 1
    (pin `IsLocalization.height…` transfers), `D' := D B' = ker(δ*_{z̃})`
    generated by the images of `x₁..x_m'` — rerun (a)'s cotangent count AT
    `z̃` (point-agnostic: both stalks regular, surjection; `m' = dim B' −
    dim 𝒪_{X,z}`); `𝔪_{B'} ∈ minimalPrimes (D' + J')` (localization of
    minimal primes, small custom lemma via `IsLocalization.AtPrime` prime
    order-iso); Krull in `B'/J'`: `dim(B'/J') ≤ m'`; **(K)** at `B'`:
    `dim(B'/J') = dim B' − 1`. Hence `dim 𝒪_{X,z} ≤ 1`; `z ≠ η_X` (else
    `h` regular at `z̃ = η_Y`… in fact `z ∈ Z(f)` below and `η_X ∈ Dom f`)
    gives `dim 𝒪_{X,z} = 1` ⟹ `coheight_X z = 1` (landed CoheightBridge).
  - (d) **`z ∈ Z(f)`**: if `f` were defined at `z`, then `δ(z) ∈ Dom Φ`
    (landed 2-easy `le_domain_differenceRationalMap`), `Φ₀(δz) = e`
    (D3 diagonal triviality), so `h` regular at `z̃` (D4 3-easy) —
    contradiction with (b).
- **D6 (component reduction: from closed points to the full ∀-statement).**
  File `Albanese/Milne33.lean`. `Z(f)` is closed; for `x ∈ Z(f)` let `C` be an
  irreducible component of `Z(f)` containing `x`, `ζ` its generic point. Pick
  a closed rational `x₀ ∈ C ∖ (other components)` (Jacobson density in the
  f.t. `k̄`-scheme; nonempty by irreducibility). D3–D5 give `z ∈ Z(f)`,
  `coheight z = 1`, `z ⤳ x₀`. Then `closure{z} ⊆ Z(f)` irreducible forces
  `closure{z} ⊆ C` (x₀ avoids other components), so `ζ ⤳ z`; if `ζ ≠ z` then
  `coheight z ≥ coheight ζ + 1 ≥ 2`, contradiction — so `ζ = z`, i.e. every
  component generic point of `Z(f)` has coheight 1, and `x ∈ closure{ζ}`
  discharges `Milne33Indeterminacy f` (second disjunct; first if `Z(f) = ∅`).
  (This is also why 2-hard is only ever invoked at closed rational points.)
- **D7 (the (K) file).** `Albanese/Milne33CMEquidim.lean` (pure algebra):
  1. *Ischebeck-lite*: for f.g. `N` over Noetherian local `R` and f.g.
     `M`, `Ext^i(N, M) = 0` for `i < depth M − dim N` — induction on
     `dim N` with the pin's prime-filtration induction principle for the
     dévissage and the `y`-multiplication SES
     `0 → R/p → R/p → R/(p+y) → 0` + contravariant Ext LES for the prime
     cyclic case (project ABDepthExt patterns; `depth_eq_smallest_ext_index`
     for the base `dim N = 0`).
     Consumer form: `p ∈ Ass R ⟹ depth R ≤ dim R/p`.
  2. *CM unmixedness*: `[CohenMacaulay R]` local ⟹ every `p ∈ Ass R` (hence
     every minimal prime, `minimalPrimes_annihilator_subset_associatedPrimes`)
     has `dim R/p = dim R`.
  3. *(K)*: `[CohenMacaulay R]` local, `p` prime ⟹
     `ht p + dim R/p = dim R`. Induction on `ht p`: base = (2);
     step: `y ∈ p ∖ ⋃ Ass R` (prime avoidance `Ideal.subset_union_prime` +
     `associatedPrimes.finite` + unmixedness to exclude `p ⊆` an associated
     prime), `R/(y)` is CM local of `dim = dim R − 1`
     (`depth_of_short_exact` inequality (2) + `depth ≤ dim` + pin dim
     identity), `ht(p/(y)) = ht p − 1` (chain lemma: `≤` elementary through
     NZD-avoiding minimal primes; `≥` by chain surgery/prime avoidance —
     check pin `Ideal.height…` quotient lemmas first, build if absent).
     Only the `ht p = 1` instance is consumed (at `B'`, D5(c)), but the
     induction is the natural statement; if the general `ht(p/(y))` surgery
     balloons, ship the `ht p = 1` case only (`p/(y)` minimal in `R/(y)`
     is immediate there).

## §2 Files, sizes, order (each ≤500L, committed green immediately)

| # | file | contents | est. |
|---|---|---|---|
| 1 | `Albanese/Milne33Diagonal.lean` | D3: rows/sections, ψ, 2-hard at closed rational pts; diagonal triviality; rational-point density helper | ~420L |
| 2 | `Albanese/Milne33Pullback.lean` | D4: Λ, spreading criterion, 3-easy, pole-existence corollary | ~450L |
| 3 | `Albanese/Milne33CMEquidim.lean` | D7: Ischebeck-lite, CM unmixedness, (K) | ~480L |
| 4 | `Albanese/Milne33Transport.lean` | D5: diagonal regular sequence, intersection point, codim count | ~420L |
| 5 | `Albanese/Milne33.lean` | D6 + assembly `indeterminacy_pure_codim_one_into_grpScheme : Milne33Indeterminacy f` (name kept from the old tree; the ledger contract only fixes the *conclusion* `Milne33Indeterminacy f`) | ~320L |

Order 1→2→3→4→5 (1, 2 are the contract-named open substeps and are
CM-independent; 3 is the mountain; each lands on its own). Root wiring per
I-0157 blob-staging; imports only LANDED files (port-ext in-flight
CodimOneMilne31/ExtensionUnique/Thm32 are NOT touched or imported — re-check
ledger before each import edit). `lean_verify` keystones: the file-5 assembly,
plus `mem_domain_of_diagonal_mem_domain`, `mem_domain_of_forall_stalk_range`,
the (K) theorem.

## §3 Risk register

- **R1 (Ischebeck dévissage, file 3)** — highest risk: pin's
  `induction_on_isQuotientEquivQuotientPrime` shape vs the needed
  "Ext-vanishing is closed under extensions" step; project `Module.depth` is
  ℕ∞-valued (arithmetic friction). Fallback: land files 1–2, file the precise
  Ext-LES/filtration blocker as an inbox issue; secondary fallback for (K):
  restrict to `ht p = 1` (all the assembly needs).
- **R2 (chart plumbing in D5(b))** — `δ`-compatibility of
  `IsAffineOpen.fromSpec` across the two charts (need: point of `Spec Γ(V)`
  ↦ `δ`-image matches `Spec` of the section map). Mitigation: PolePurity's
  landed chart patterns; worst case prove the needed square by hand via
  `Scheme.Hom.appLE` naturality. Genuine but bounded.
- **R3 (pullback.lift diagram algebra in ψ, file 1)** — `precomp`-unfolding
  transparency walls (documented kernel-discipline hazard). Mitigation:
  opaque top-level defs for every repeated composite (the landed
  `precompDiffPairing` pattern), `ext_of_isDominant_of_isSeparated` instead
  of pointwise reasoning, never `rw` at hypotheses over Spec towers.
- **R4 (instance friction: `Smooth`/`IsLocallyNoetherian`/fraction-ring towers
  on `Y`)** — mitigations: the landed files already register these patterns;
  carry `set_option maxSynthPendingDepth 3` in-file if I-0161 bites.
- **R5 (κ(x₀) = k̄ plumbing)** — `pointOfClosedPoint` (pin) requires the
  closed-point rationality; landed port-ext stage 3 has the Zariski-lemma
  bridge; density of closed points needs the Jacobson instance for f.t.
  schemes over fields — verify early in file 1; if the instance chain is
  absent, build the small chart-level density lemma directly.

Fallback global posture: every file is independently valuable and lands
alone; if a later file balloons, the landed ones stay, the roadmap item
records exactly which D-decision blocked and why.
