# SPEC DAT-A — sections ↦ divisor families, with the lm:ctn regularity half (DAT-A2)
(`AJCR.w4-rep.datum.dat-a`)

*Derived from the BINDING worksheet `informal/w4-datum-worksheet.md` (§2.2 step 2, §4
DAT-A, §5 risk 4), Kleiman `references/kleiman-picard-src/kleiman-picard.tex` (`lm:ctn`
tex 1733–1816, the (iii)⟹(i) Tor argument tex 1786–1815; the fibrewise-nonzero ⟹ regular
slicing tex 2013–2022), the landed DAT-1 lane (`informal/spec-dat-1.md`;
`Cohomology/GluedSheaf{,Qcoh,Pair,Module,Datum,Engine}.lean` read in full), and the
divisor carriers (`Picard/DivisorClass.lean` `LocalEquations` :112, `picClass` :238;
`Picard/MeromorphicPresentation.lean`). Mathlib claims verified by grep/read against the
pinned v4.31.0 checkout (`/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib`),
cited `file:line`. Third launch of this brick; nothing landed by predecessors.*

## 0. Mathlib search verdict (worksheet §5 risk 4, mandated)

The slicing/regularity criterion itself is **NOT in mathlib** (leansearch + leanfinder +
targeted greps over `RingTheory/Flat/*`, `RingTheory/Regular/*`: only the *converse*
directions exist — `IsSMulRegular.of_isLocalization` `Flat/Localization.lean:125`,
`IsWeaklyRegular.of_flat` `Regular/Flat.lean:47`, `Flat.isSMulRegular_of_nonZeroDivisors`
`Flat/TorsionFree.lean:79`). Hand-roll per §1. Every supporting piece IS a mathlib gift:

- `IsNoetherian.induction` (`RingTheory/Noetherian/Basic.lean:244`);
- `Module.Flat.lTensor_preserves_injective_linearMap` (`Flat/Basic.lean:131`);
- `TensorProduct.tensorQuotEquivQuotSMul` + `_tmul_mk` + `_symm_mk`
  (`LinearAlgebra/TensorProduct/Quotient.lean:164,207,218`) — kills all ker-extraction:
  the two flat inputs below are *injectivity of a composite*, no `Function.Exact`;
- `Ideal.ResidueField` full API (`RingTheory/LocalRing/ResidueField/Ideal.lean`):
  `Algebra (R ⧸ I) I.ResidueField` :85, `IsScalarTower R (R ⧸ I) I.ResidueField` :89,
  `Ideal.injective_algebraMap_quotient_residueField` :103,
  `Ideal.algebraMap_residueField_eq_zero` :73;
- `Submodule.mem_colon_singleton` (`RingTheory/Ideal/Colon.lean:48`),
  `Submodule.sup_smul`, `Submodule.ideal_span_singleton_smul`, `Submodule.map_smul''`
  (`Ideal/Operations.lean:339,220,102`);
- germ side: `IsAffineOpen.isLocalization_stalk` (`AlgebraicGeometry/AffineScheme.lean:816`),
  `IsSMulRegular.of_isLocalization` (as above), stalk `IsDomain` +
  `germ_injective_of_isIntegral` (`AlgebraicGeometry/FunctionField.lean:171,55`);
- generators side: `Module.freeLocus_eq_univ` + `mem_freeLocus`
  (`RingTheory/Spectrum/Prime/FreeLocus.lean:164,54`),
  `Module.FinitePresentation.exists_free_localizedModule_powers`
  (`RingTheory/Localization/Free.lean:78` — outputs `Module.Free (Localization (.powers r))
  (LocalizedModule.Away r M)`), `Basis.baseChange_apply`
  (`LinearAlgebra/TensorProduct/Basis.lean:73`), `Module.finitePresentation_of_projective`.

## 1. DAT-A2 core — the lm:ctn-lite slicing lemma (Kleiman (iii)⟹(i), Tor-free spelling)

**TOR-LEMMA HOME (fixed by this commit, per the coordination rule):**
`Picard/FibrewiseRegular.lean`. The DD-1 lane (dat-d-worksheet §1.2 DD-1a, §3.4 DD-R)
shares this file: DD-R consumes the lemmas below by name; DD-1a's *other* lm:ctn half
((i)⟹ base-change stability via `Tor₁(B/(f), R') = 0`, tex 1747–1770) is to be ADDED to
this file by the DD-1 lane — a marked seam section, do not duplicate elsewhere.

Proof route (replaces the paper's Tor/local-criterion computation; same content,
kernel-cheaper): **Noetherian induction on ideals** with the predicate
`P I := ∀ x, φ x ∈ I • ⊤ → x ∈ I • ⊤`, via `IsNoetherian.induction`:

- `I = ⊤`: trivial.
- `I` prime: `φ x ∈ p•⊤ ⟹ (φ.rTensor κ(p))(x ⊗ₜ 1) = φ x ⊗ₜ 1 = 0` (elements of `p•⊤`
  tensor-to-zero: `smul_induction_on` + `algebraMap_residueField_eq_zero`); fibre
  injectivity gives `x ⊗ₜ 1 = 0`; then `x ∈ p•⊤` because
  `ψ : M⧸p•⊤ ≃ M ⊗ (R⧸p) → M ⊗ κ(p)` (`tensorQuotEquivQuotSMul.symm` then `lTensor` of
  `(Algebra.linearMap (R⧸p) κ(p)).restrictScalars R`) is injective by flatness +
  `injective_algebraMap_quotient_residueField`, and `ψ (mk x) = x ⊗ₜ 1`. **No IH used.**
- `I` not prime, `≠ ⊤`: pick `a, b ∉ I`, `a*b ∈ I`. With `J₁ := I ⊔ span{a} > I` and
  `J₂ := I.colon {a} > I` (`b ∈ J₂ ∖ I`): from `φ x ∈ I•⊤ ≤ J₁•⊤` and `P J₁`,
  `x = y + a•z`, `y ∈ I•⊤`; `φ` R-linear ⟹ `φ y ∈ I•⊤` (`map_smul''`), so
  `a • φ z ∈ I•⊤`; the **flat colon lemma** gives `φ z ∈ J₂•⊤`; `P J₂` gives
  `z ∈ J₂•⊤`; `a • (J₂•⊤) ≤ I•⊤` (`smul_induction_on`, `a*j ∈ I`); so `x ∈ I•⊤`.
- **Flat colon lemma** (the file's second flat input): for flat `M`, `a•x ∈ I•⊤ ⟹
  x ∈ (I.colon {a})•⊤`. Proof: `g : R⧸(I.colon {a}) →ₗ[R] R⧸I`, `r ↦ r*a`
  (`Submodule.mapQ` of `lsmul a`), is INJECTIVE by definition of colon; so
  `tensorQuotEquivQuotSMul ∘ (g.lTensor M) ∘ tensorQuotEquivQuotSMul.symm :
  M⧸(I.colon{a})•⊤ → M⧸I•⊤` is injective and sends `mk x ↦ mk (a•x)` (the two simp
  lemmas); conclude.

Conclusion `P ⊥` = injectivity. Declarations (`Picard/FibrewiseRegular.lean`, ≤ ~350):

```lean
theorem Module.Flat.mem_colon_smul_top_of_smul_mem_smul_top   -- flat colon lemma
theorem tmul_residueField_one_eq_zero_of_mem_smul_top          -- p•⊤ ⊗ 1 = 0
theorem Module.Flat.mem_smul_top_of_tmul_residueField_one_eq_zero  -- ψ-injectivity, p prime
theorem Module.Flat.injective_of_forall_rTensor_residueField_injective  -- THE CORE
    {R : Type u} [CommRing R] [IsNoetherianRing R] {M : Type u} [AddCommGroup M]
    [Module R M] [Module.Flat R M] (φ : M →ₗ[R] M)
    (hfib : ∀ p : PrimeSpectrum R, Function.Injective (φ.rTensor p.asIdeal.ResidueField)) :
    Function.Injective φ
theorem Module.Flat.mem_nonZeroDivisors_of_forall_tmul_residueField  -- ring form
    {R A : Type u} [CommRing R] [IsNoetherianRing R] [CommRing A] [Algebra R A]
    [Module.Flat R A] {s : A}
    (hfib : ∀ p : PrimeSpectrum R, (s ⊗ₜ 1 : A ⊗[R] p.asIdeal.ResidueField) ∈
      nonZeroDivisors (A ⊗[R] p.asIdeal.ResidueField)) : s ∈ nonZeroDivisors A
```

with the bridge `(LinearMap.mulLeft R s).rTensor κ = mulLeft _ (s ⊗ₜ 1)`
(`TensorProduct.ext'` + `Algebra.TensorProduct.tmul_mul_tmul`) and the
`mem_nonZeroDivisors ↔ Injective mulLeft` conversion (comm ring). The engine's residue
spelling `p.asIdeal.ResidueField` is used verbatim (matches `datumRigidEngine`'s `hfib`).
`[IsNoetherianRing R]`: route-consistent — `datumRigidEngine` already takes it, and
(V-rel-B) runs over the RE-5 Noetherian stage `B₀`. Noetherian-free is NOT attempted
(the non-Noetherian statement needs finite presentation of the pair, off-route).

## 2. DAT-A2 geometry — germ regularity on the datum (`Picard/SectionsToDivisors.lean`)

Generic layer (the (D3)/(D5) discipline of `GluedSheafModule.lean` inherited verbatim:
`attribute [local instance] Scheme.overModule`, `letI : Algebra B Γ(X,V) :=
(X.overAlgebraMap B V).toAlgebra`, fibre hypotheses through `Scheme.mulSectionEnd`):

- (α) **germ transport**: `IsAffineOpen.germ_mem_nonZeroDivisors` — a nonzerodivisor of
  `Γ(X, U)` (`U` affine) has nonzerodivisor germs at all points of `U`
  (`isLocalization_stalk` + `IsSMulRegular.of_isLocalization`; the stalk algebra is
  `TopCat.Presheaf.algebra_section_stalk`, whose `algebraMap` is the germ hom). This is
  also DD-1a's "germ-level regularity by localization-exactness" consumption surface.
- (slice) **the field-level slice case, its own named lemma** (Kleiman tex 2013–2022):
  `Scheme.germ_mem_nonZeroDivisors_of_ne_zero [IsIntegral X] : t ≠ 0 →` all germs of
  `t ∈ Γ(X, U)` are nonzerodivisors (`germ_injective_of_isIntegral` + stalk `IsDomain`).
  This is what DAT-C discharges at field-level fibres.
- (β) **piece flatness**: `V` affine, `Module.Flat B Γ(X,V)` (overModule) ⟹
  `Module.Flat B Γ(X, X.basicOpen h)` — tower `B → Γ(V) → Γ(D(h))`
  (`IsScalarTower` from `overAlgebraMap_apply_res`; `isLocalization_basicOpen` +
  `IsLocalization.flat` + `Module.Flat.trans`). At the pinned charts flatness of `Γ(V)`
  comes from `free_relSections` (the `projective_sections₀/₁/Inf` pattern,
  `GluedSheafEngine.lean:134–174`).
- (γ) **A2 generic**: `[IsNoetherianRing B]`, `V` affine, `Γ(V)` B-flat, `h : Γ(X,V)`,
  `t : Γ(X, X.basicOpen h)`, fibre hypothesis
  `∀ p, Function.Injective ((Scheme.mulSectionEnd B t).rTensor p.asIdeal.ResidueField)`
  ⟹ `t ∈ nonZeroDivisors Γ(X, X.basicOpen h)` (+ germ form via (α)). A conversion lemma
  from the tensor-RING spelling (`t ⊗ₜ 1 ∈ nonZeroDivisors (Γ(D(h)) ⊗[B] κ(p))`, with the
  `letI` algebra) is provided for consumers holding fibre-curve ring statements.
- (δ) **A2 on the pinned datum**: for `D : BasicOpenCocycleDatum C B π`,
  `s ∈ gluedSubmodule B D.pieces D.unit ⊤`, `D.component s j := resHom (le_inf le_top
  le_rfl) (s.val j) : Γ(pieces j)`; `[IsNoetherianRing B]` + per-piece fibre hypothesis
  ⟹ every `component` is a section-ring nonzerodivisor with nonzerodivisor germs on its
  piece. (Statement per piece `j : D.index`, `Sum.rec` over the two charts for freeness.)

**Hypothesis interface decision (binding).** The primitive fibrewise hypothesis is
*fibrewise-regularity of each component in its piece-ring fibre* (rTensor-injectivity
form). Rationale: (i) "nonzerodivisor in the fibre" is vacuously true on pieces missing
a fibre (zero ring) — "nonzero on the fibre" is not; (ii) it is exactly what the
integral-fibre slice case produces where the fibre ring is a domain (Kleiman's
`σ_t ≠ 0 ⟹ regular`); (iii) it avoids the un-landed 1d-ii/DAT-3 fibre-sheaf
identifications — those seams stay with their owners (DAT-C/DD-R bridge their
fibre-curve statements to this spelling through the base-change isos they already carry).

## 3. DAT-A main — sections ↦ LocalEquations + the class law
(`Picard/SectionsToDivisorsClass.lean`)

For a choice function `σ : relCurve C B → D.index` with `hσ : ∀ y, y ∈ D.pieces (σ y)`
(existence: `exists_mem_pieces` from `relCover_sup` + `cover₀/cover₁`):

- `D.pointedCover σ hσ : (relCurve C B).PointedCover`, members `D.pieces (σ y)`.
- `D.sectionLocalEquations s σ hσ hgerm : (relCurve C B).LocalEquations` — `eqn y :=
  D.component s j` at `j = σ y`; `regular` = the input `hgerm` (fed by §2 (δ)
  relatively, by (slice) at field level); `ratio_isUnit` witnessed by
  `D.unit (σ y) (σ y')` — the matching relation of `s` restricted to
  `pieces (σ y) ⊓ pieces (σ y')` (which is EXACTLY the units' home — no transport).
- **ratio units exactly the cocycle's transition units**:
  `(D.sectionLocalEquations …).ratioUnit y y' = D.unit (σ y) (σ y')`
  (`ratioUnit_unique`).
- **the datum's class on the chosen cover**: `D.cocycleClassOn σ hσ : CechPic :=
  CechPic.mk (D.pointedCover σ hσ) (class of the pulled-back cocycle)` (the pulled-back
  cocycle is `OneCocycle.ofPairs (fun y y' ↦ D.unit (σ y) (σ y'))`, trans from
  `IsGluingCocycle.mul_res_of_le` — the triple overlap is on-the-nose).
- **CLASS LAW**: `(D.sectionLocalEquations s σ hσ hgerm).picClass = D.cocycleClassOn σ hσ`
  — by `unitsCocycle_ext` + `ratioUnit = unit`, near-definitional.
- **choice-independence** (refinement naturality): `D.cocycleClassOn σ hσ =
  D.cocycleClassOn σ' hσ'` — compare on the inf pointed cover; the 0-cochain
  `α y := (restriction of) D.unit (σ y) (σ' y)` conjugates one restricted cocycle into
  the other by two cocycle identities (`unitsCocycle_isCohomologous`,
  `CechPic.mk_unitsRes`, `mk_eq_mk_iff`).
- **rescaling naturality**: components multiplied by the restrictions of one global unit
  `u ∈ Γ(relCurve C B, ⊤)ˣ` yield the `LocalEquations.rescale` of the original —
  `picClass` unchanged by the landed `picClass_rescale`; cover refinement is the landed
  `picClass_restrict`. (Both landed laws are the consumption surface; only the
  section-level compatibility lemma is new.)

**(1e) seam (recorded).** DAT-1's finisher owns `Cohomology/GluedSheafClass.lean` /
`BasicOpenCocycleDatum.cechPicClass` (stage 1e), not landed at spec time. The class law
above is stated against `D.cocycleClassOn` (the cocycle's `CechPic` class directly, as
sanctioned). When (1e) lands, the one-lemma seam `D.cocycleClassOn σ hσ =
D.cechPicClass` closes it (both are `CechPic.mk` of unit cocycles with the same pair
values on a common refinement); ledger to be re-checked at wiring time.

## 4. Generators corollary (worksheet §2.2.3a) — `Picard/LocalGenerators.lean`

Pure module algebra, stated for DAT-B/DD-R verbatim consumption (the `H⁰` instance is
the engine clause `datumRigidEngine`'s finite projective `Sheaf.HModule D.sheaf 0`; the
`Nontrivial` fibre input is the rank clause they hold via FLV/DAT-3):

```lean
theorem Module.exists_fibrewise_tmul_ne_zero_of_projective
    {B Q : Type u} [CommRing B] [AddCommGroup Q] [Module B Q]
    [Module.Finite B Q] [Module.Projective B Q] (p : PrimeSpectrum B)
    (hp : Nontrivial (Q ⊗[B] p.asIdeal.ResidueField)) :
    ∃ f : B, f ∉ p.asIdeal ∧ ∃ q : Q, ∀ q' : PrimeSpectrum B, f ∉ q'.asIdeal →
      (q ⊗ₜ 1 : Q ⊗[B] q'.asIdeal.ResidueField) ≠ 0
```

Route: finite + projective ⟹ finitely presented + flat; `freeLocus_eq_univ` gives
`Module.Free (Localization.AtPrime p) (LocalizedModule.AtPrime p Q)`;
`exists_free_localizedModule_powers` at `S = p.asIdeal.primeCompl` yields `f ∉ p` with
`Q_f := LocalizedModule.Away f Q` free over `B_f := Localization.Away f`; `Q_f`
nontrivial (else `Q ⊗ κ(p)` is trivial by the `f`-inversion trick — `mk q = 0 ⟹
f^n • q = 0 ⟹ q ⊗ₜ c = (f^n • q) ⊗ₜ (f⁻ⁿ c) = 0` on generators), so a basis element
exists and is `unit • mk q` for a global `q : Q`; at `q' ∈ D(f)`: `κ(q')` is a
`B_f`-algebra (`f ∉ q'` ⟹ `algebraMap B κ(q') f ≠ 0` ⟹ unit; `IsLocalization.Away.lift`,
tower by `of_algebraMap_eq`), the canonical `B`-linear `χ : Q ⊗[B] κ(q') →
Q_f ⊗[B_f] κ(q')` (TensorProduct.lift) sends `q ⊗ₜ 1` to `unit-scalar • (basis elt ⊗ 1)`,
which is nonzero in the free module (`TensorProduct.comm` + `Basis.baseChange_apply` +
`Basis.ne_zero`, `κ(q')` a field). Hence `q ⊗ₜ 1 ≠ 0`.

"Zariski-locally a fibrewise-nonzero section EXISTS": the section is `q` (a GLOBAL
element of `Q`, fibrewise nonzero over the basic open `D(f)` ∋ p) — consumers restrict
their datum to `D(f)` with their own base-change kit; no localized `H⁰` is built here
(1d-ii stays with its owner).

## 5. Files, staging, discipline

| Stage | File | Content | Size |
|---|---|---|---|
| A2-core | `Picard/FibrewiseRegular.lean` | §1 (shared Tor home) | ≤ ~350 |
| A2-geo | `Picard/SectionsToDivisors.lean` | §2 (α)(slice)(β)(γ)(δ) | ≤ ~450 |
| A | `Picard/SectionsToDivisorsClass.lean` | §3 construction + class law | ≤ ~450 |
| gen | `Picard/LocalGenerators.lean` | §4 | ≤ ~250 |

Commit each stage green (private-index + CAS per `informal/protocol-concurrent-lanes.md`;
`show --stat HEAD` verification — 6+ sibling lanes). Root wiring: one import line per
stage into `AlgebraicJacobian.lean`, re-read immediately before each edit (the DAT-3 and
RE-5 lanes are appending lines tonight). Lake mutex: mkdir DIRECTORY lock at
`/tmp/claude-1001/ajcr-locks/lake.lock`, plain-file-is-stale detection. Zero sorries;
`set_option autoImplicit false`; explicit binders; keystones `lean_verify` axiom-clean
`[propext, Classical.choice, Quot.sound]`. Keystones to verify: the §1 core, the §2 (δ)
datum theorem, the §3 class law, the §4 corollary.

**Done-criterion (roadmap `AJCR.w4-rep.datum.dat-a`):** A2 + A + class law green;
generators corollary green closes the full brick.

## 6. Consumer API map

| Consumer | Calls |
|---|---|
| DAT-C (canonical section, field-level normalization) | `germ_mem_nonZeroDivisors_of_ne_zero` (slice), `sectionLocalEquations` + class law + `ratioUnit` pin |
| DD-R (relative endgame, dat-d §3.4) | `Module.Flat.injective_of_forall_rTensor_residueField_injective` + ring form (the "fibrewise-regular + flat ⟹ regular" bridge by name), (α) germ transport, (δ) |
| DD-1a (certified pullback) | (α) germ transport; ADDS its (i)⟹base-change Tor half to `FibrewiseRegular.lean` (seam marked in the file) |
| DAT-B (coverage) | §4 generators corollary + (δ) + `sectionLocalEquations` |
| DAT-1 (1e) finisher | the §3 (1e) seam lemma target `cocycleClassOn = cechPicClass` |

*End of spec. Binding for the DAT-A stages; deviations require re-derivation from the
worksheet and a note in the stage commit message.*

---

**LANDING ADDENDUM (same day, post-close).** All four stages landed
(`Picard/FibrewiseRegular.lean`, `SectionsToDivisors.lean`, `SectionsToDivisorsClass.lean`,
`LocalGenerators.lean`; keystones axiom-clean). One deviation, in the sanctioned
direction: DAT-1's stage (1e) (`Cohomology/GluedSheafClass.lean`) landed mid-flight, so
§3's interim class carrier `cocycleClassOn` and its seam were **never built** — the
LocalEquations construction was instead stated on the (1e) subordination interface
(`𝒲, σ, hσ` with equations the `resHom (hσ y)`-restricted components and ratio units
`gluedSubordUnit`), and the class law is
`sectionLocalEquations_picClass : (…).picClass = D.cechPicClass` on the nose (via
`cechPicClass_eq_mk`); choice/refinement naturality is the landed
`gluedSubordCocycle_class_eq`. The A2-bundled wrapper instantiates at the canonical
`D.pointedCover`/`D.pieceIndex`. §4's corollary landed with a coordinate-functional
evaluation instead of the `χ`-map into the localized tensor (no localized tensor
products are formed). The DD-1a seam in `FibrewiseRegular.lean` remains open as
specified.*
