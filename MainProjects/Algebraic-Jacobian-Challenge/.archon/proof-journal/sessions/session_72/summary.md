# Session 72 — iter-072 review

## Metadata

- **Archon iteration**: 072
- **Stage**: prover (four parallel lanes: AbelJacobi, BasicOpenCech, Differentials, Jacobian)
- **Sorry count before iter-072** (active syntactic sites, per-file):
  - AbelJacobi 3 + Differentials 8 + BasicOpenCech 6 + Jacobian 1 + Picard/Functor 1 = **19**.
- **Sorry count after iter-072**:
  - AbelJacobi 1 + Differentials 7 + BasicOpenCech 6 + Jacobian 1 + Picard/Functor 1 = **16**.
- **Net change**: **−3 sorries** (AbelJacobi −2, Differentials −1).
- **Compilation status**: project `lake build` continues to fail with `unknown module prefix 'Mathlib'`
  due to root-owned `.lake/packages/{doc-gen4,checkdecls,mathlib}`. Each prover reported
  `error_count: 0` from `lean_diagnostic_messages` against the cached oleans during its run, and
  the `lean_run_code` sandbox confirmed each closure pattern in isolation. Treat compilation as
  **provisionally clean**; the next plan agent should ask the user to repair the build env.

---

## Prover attempt analysis (from `attempts_raw.jsonl`)

The pre-processed attempt log records **183 events**: 7 edits across 3 source files
(`AbelJacobi.lean`, `BasicOpenCech.lean`, `Differentials.lean`, `Jacobian.lean`),
5 goal checks, 7 diagnostic checks, 0 builds (build env broken), 10 lemma searches.
All recorded diagnostics for the changed files reported `error_count: 0` (`clean: true`).

### Lane 1 — `Jacobian.lean` (structural refactor for Lane 2)

**Status**: STRUCTURAL — sorry count **1 → 1**, but `JacobianWitness` reshaped to
unblock `AbelJacobi.lean`.

#### Edit 1 — Drop `P` field, generalise `isAlbanese` to `isAlbaneseFor` (raw log ~10:50:24 UTC, Jacobian.lean L113–162)
- **Strategy**: rewrite the `JacobianWitness` structure so the Albanese property is
  uniform over the marked point: drop `P : 𝟙_ _ ⟶ C`, rename `isAlbanese` →
  `isAlbaneseFor : ∀ (P : 𝟙_ _ ⟶ C), IsAlbanese C P J` (dependent on `J`,
  `grpObj`, `proper`, `smooth`, `geomIrred` only).
- **Code tried** (key change):
  ```lean
  structure JacobianWitness (C : Over (Spec (.of k)))
      [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
      [GeometricallyIrreducible C.hom] where
    J : Over (Spec (.of k))
    grpObj : GrpObj J
    proper : IsProper J.hom
    smooth : Smooth J.hom
    geomIrred : GeometricallyIrreducible J.hom
    smoothGenus : SmoothOfRelativeDimension (genus C) J.hom
    isAlbaneseFor : ∀ (P : 𝟙_ _ ⟶ C),
      @IsAlbanese k _ C P J grpObj proper smooth geomIrred
  ```
- **Goal context**: each of the four protected instances projects a `P`-independent
  field; only the Albanese predicate is `P`-dependent. The four protected
  signatures are unchanged; only the underlying `JacobianWitness` field set
  changes.
- **Result**: SUCCESS (structural). LSP `lean_diagnostic_messages` returned `clean: true`
  for `Jacobian.lean` after the edit.
- **Insight**: the iter-071 review's recommended Route 1 (parameterise by `P`) is
  redundant — the same effect can be obtained by storing a `Π P, IsAlbanese C P J`
  family inside the witness without changing the existence statement of `J`. This
  is mathematically correct because the Jacobian variety carries the universal
  property uniformly over $k$-rational points.

#### Edit 2 — Docstring update (raw log ~10:50:35 UTC, Jacobian.lean ~L150–172)
- **Strategy**: extend the docstrings on `JacobianWitness` and
  `nonempty_jacobianWitness` to explain the `∀ P` design.
- **Result**: SUCCESS — purely documentation; no semantic change.

**Net for Jacobian.lean**: 1 → 1 sorries. The single remaining sorry
(`nonempty_jacobianWitness` L172) is unchanged but its docstring now reflects
the wider universal-property guarantee.

---

### Lane 2 — `AbelJacobi.lean` (Phase E unblocked)

**Status**: HIGH-VALUE PARTIAL — sorry count **3 → 1**.

#### Edit — Full file rewrite (raw log ~10:56:55 UTC, AbelJacobi.lean L1–end)
The prover replaced the entire scaffold with a `dite`-aware implementation.
Three protected declarations are now closed up to a single rigidity-blocked sorry.

##### `ofCurve P` (L51) — RESOLVED
- **Strategy**: `unfold Jacobian; split_ifs with h`.
  - Genus-0 branch: return `toUnit C : C ⟶ 𝟙_ _` (the unique morphism into
    the terminal object).
  - Genus>0 branch: `letI` the four `(jacobianWitness C).{grpObj, proper, smooth, geomIrred}`
    fields as local instances, then `exact ((jacobianWitness C).isAlbaneseFor P).ofCurve`.
- **Code tried**:
  ```lean
  noncomputable def ofCurve (P : 𝟙_ _ ⟶ C) : C ⟶ Jacobian C := by
    unfold Jacobian
    split_ifs with h
    · exact toUnit C
    · letI := (jacobianWitness C).grpObj
      letI := (jacobianWitness C).proper
      letI := (jacobianWitness C).smooth
      letI := (jacobianWitness C).geomIrred
      exact ((jacobianWitness C).isAlbaneseFor P).ofCurve
  ```
- **Result**: RESOLVED. The `def` was promoted to `noncomputable def` (allowed
  under the 2026-05-07 user authorisation; the genus>0 branch goes through
  `Classical.choose` on the `IsAlbanese` existential).
- **Insight**: The protected signature is preserved verbatim; only the proof
  body and the `noncomputable` modifier change. The pattern transports cleanly
  to `comp_ofCurve` and `exists_unique_ofCurve_comp`.

##### `comp_ofCurve P` (L68) — RESOLVED
- **Strategy**: `unfold ofCurve Jacobian; split_ifs with h`.
  - Genus-0: both sides live in `Hom(𝟙_ _, 𝟙_ _) = Subsingleton`; close
    with `Subsingleton.elim`.
  - Genus>0: `letI` instances, then `exact ((jacobianWitness C).isAlbaneseFor P).comp_ofCurve`.
- **Key Mathlib facts used**:
  - `CartesianMonoidalCategory.Basic.lean:70`: `instance (X : C) : Unique (X ⟶ 𝟙_ C)`,
    giving `Subsingleton (𝟙_ _ ⟶ 𝟙_ _)`.
  - `Mon_.lean:132–137`: standard `MonObj (𝟙_ C)` instance with `one := 𝟙 _`,
    so `η[𝟙_ _] = 𝟙 (𝟙_ _)` reduces by `rfl`.
- **Result**: RESOLVED.

##### `exists_unique_ofCurve_comp P f hf` (L92) — PARTIAL (genus-0 existence sorry)
- **Strategy**: `unfold ofCurve Jacobian; split_ifs with h`.
  - Genus>0 branch: project to `((jacobianWitness C).isAlbaneseFor P).exists_unique_ofCurve_comp f hf`.
    **RESOLVED**.
  - Genus-0 branch: `refine ⟨η[A], ?existence, ?uniqueness⟩`.
    - **Uniqueness** (RESOLVED): given `hg' : f = toUnit C ≫ g'`, precompose with
      `P`: `P ≫ f = (P ≫ toUnit C) ≫ g' = 𝟙 (𝟙_ _) ≫ g' = g'` (using
      `Subsingleton.elim` on `P ≫ toUnit C : 𝟙_ _ ⟶ 𝟙_ _`). Combined with
      `hf : P ≫ f = η[A]`, we get `g' = η[A]`. Inline at L113–123.
    - **Existence** (SORRY at L111): need `f = toUnit C ≫ η[A]`. This is the
      classical rigidity claim: every morphism `f : C ⟶ A` from a smooth proper
      geometrically irreducible genus-0 curve to an abelian variety with
      `f ∘ P = η[A]` is the constant map at `η[A]`. Equivalently,
      `Hom(C, A) = A(k)` once `genus C = 0`.
- **Why the rigidity sorry stays**:
  - Over an algebraically closed field, genus-0 smooth proper geometrically
    irreducible curves are `ℙ¹`, and `Hom(ℙ¹, A) = A(k)` for `A` an abelian
    variety (`Pic⁰(ℙ¹) = 0`, so any morphism is a translate of a trivial-line-bundle
    morphism, hence constant).
  - Over a general field `k`, genus-0 curves with a `k`-rational point are still
    isomorphic to `ℙ¹_k`, but the proof requires Brauer–Severi machinery.
  - Neither route is currently formalised in Mathlib (no `Hom(ℙ¹, A) = A(k)`,
    no general Mumford §4 rigidity for morphisms to abelian varieties). The
    project-local `GrpObj.eq_of_eqOnOpen` in `Rigidity.lean` proves a *related*
    but weaker rigidity (two morphisms agreeing on a dense open agree everywhere);
    it does not yield "morphism from genus-0 curve is constant".
- **Insight**: This is on par with `nonempty_jacobianWitness` as a major
  mathematical obligation — multi-week effort even with full Mathlib support.

**Net for AbelJacobi.lean**: 3 → 1 sorries (−2).

---

### Lane 3 — `Differentials.lean` (cotangent exact sequence, Alpha closure)

**Status**: PARTIAL — sorry count **8 → 7** (target sorry L242 fully closed).

#### Edit — Replace `cotangentExactSeqAlpha` inner sorry with a full `Derivation'` (raw log ~10:58:32 UTC, Differentials.lean L237–278)
- **Strategy**: construct a concrete `Derivation' φ_g'` of the pushed-forward target
  `M_pushed := (PresheafOfModules.pushforward f.toRingCatSheafHom.hom).obj
   (relativeDifferentialsPresheaf (f ≫ g))` and feed it to
  `(PresheafOfModules.DifferentialsConstruction.isUniversal' φ_g').desc`.
- **Code tried** (the four `Derivation'` fields):
  ```lean
  let D_X := PresheafOfModules.DifferentialsConstruction.derivation' φ_fg'
  let adj_f := TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base
  let d_target : ((PresheafOfModules.pushforward f.toRingCatSheafHom.hom).obj
      (relativeDifferentialsPresheaf (f ≫ g))).Derivation' φ_g' :=
    { d := fun {U} => AddMonoidHom.mk' (fun b => D_X.d ((f.c.app U).hom b)) (by intro a b; simp)
      d_mul := by
        intro U a b
        dsimp only [AddMonoidHom.mk', AddMonoidHom.coe_mk, ZeroHom.coe_mk]
        rw [(f.c.app U).hom.map_mul, D_X.d_mul]
        rfl
      d_map := by
        intro U V f' x
        dsimp only [...]
        have hnat' : (f.c.app V).hom (Y.presheaf.map f' x) =
            X.presheaf.map ((TopologicalSpace.Opens.map f.base).map f'.unop).op
              ((f.c.app U).hom x) := by
          have := congr_arg (fun h => ConcreteCategory.hom h x) (f.c.naturality f')
          simpa using this
        rw [hnat']
        exact (D_X.d_map _ _).symm
      d_app := by
        intro U a
        dsimp only [...]
        have hcomm : φ_g' ≫ f.c =
            (adj_f.unit.app ((TopCat.Presheaf.pullback CommRingCat g.base).obj S.presheaf)) ≫
              (TopCat.Presheaf.pushforward CommRingCat f.base).map φ_fg' := rfl
        have hcomm_app : (f.c.app U).hom (φ_g'.app U a) =
            (φ_fg'.app (op ((TopologicalSpace.Opens.map f.base).obj U.unop))).hom
              ((adj_f.unit.app _).app U a) := by
          have h1 := congr_arg (fun h => ConcreteCategory.hom (NatTrans.app h U) a) hcomm
          simpa using h1
        rw [hcomm_app]
        exact D_X.d_app _ }
  let presheafHom : relativeDifferentialsPresheaf g ⟶
      (PresheafOfModules.pushforward f.toRingCatSheafHom.hom).obj
        (relativeDifferentialsPresheaf (f ≫ g)) :=
    (PresheafOfModules.DifferentialsConstruction.isUniversal' φ_g').desc d_target
  exact ⟨presheafHom⟩
  ```
- **Diagnostics after edit**: `lean_diagnostic_messages` returned `clean: true`.
- **Result**: RESOLVED.
- **Insight (worth recording)**: the adjunction-coherence identity
  `φ_g' ≫ f.c = adj_f.unit.app _ ≫ (pushforward f.base).map φ_fg'` is **definitional**
  (`rfl`) in this setup, because the composition of pullback adjunctions for `f`
  and `g` factors definitionally through the unit/counit of the composed adjunction,
  and `(f ≫ g).c = g.c ≫ (pushforward g.base).map f.c` (`rfl` via
  `LocallyRingedSpace.comp_c`). This pattern is reusable for any pushforward+pullback
  derivation transport along a composition.

#### Stretch target NOT attempted: `cotangentExactSeq_structure.h_epi` (L368)
- **Approach considered**: reduce `Epi` of the underlying `PresheafOfModules`
  morphism via `PresheafOfModules.epi_iff_surjective`, then conclude pointwise
  via `KaehlerDifferential.map_surjective`.
- **Blocker**: Mathlib lacks a direct `SheafOfModules.epi_of_epi_presheaf` lemma.
  Without that lemma, the reduction step requires either a sheafification argument
  (Stacks 0098 — substantial infrastructure) or a project-local helper
  `lemma SheafOfModules.epi_of_epi_presheaf`. The prover declined to write a new
  helper and recorded this as the next-iteration target.

**Net for Differentials.lean**: 8 → 7 sorries (−1). The remaining seven are
L122 (`relativeDifferentialsPresheaf_isSheaf` — off-limits), L359/L363/L368
(`_structure.h_zero/h_exact/h_epi` — `h_zero/h_exact` newly attackable now that
Alpha is closed), L413 (`smooth_iff_locally_free_omega` — off-limits), L430
(`cotangent_at_section` — off-limits), L572 (`serre_duality_genus` — off-limits).

---

### Lane 4 — `BasicOpenCech.lean` (Cluster (b) `map_smul'` transport)

**Status**: STRUCTURAL — sorry count **6 → 6**, but the iter-071 `map_smul'`
sorries (L974/L983) are now reduced to two new helper claims via clean transport.

#### Edit 1 — Hoist `Z_i`/`e_i`/`h_mod_pi_i` to outer scope (raw log ~10:59:20 UTC, BasicOpenCech.lean L887–956)
- **Strategy**: lift the explicit product types `Z₁`/`Z₂`/`Z₃`, the `LinearEquiv`
  handles `e₁`/`e₂`/`e₃ : ↑(∏ᶜ Z_i) ≃ₗ[k] (∀ i, Z_i)` (from `ModuleCat.piIsoPi`),
  and the pointwise `R`-module structures `h_mod_pi_i : Module R (∀ i, Z_i)` to
  the outer scope of `h_K₀_exact` so they are in scope for the `f_R`/`g_R`
  `let`-bindings and inside `map_smul'`.
- **Goal**: with `e_i` in outer scope, `Equiv.smul_def` (the additive-side rfl-lemma
  defined in `Mathlib/Algebra/Group/TransferInstance.lean`) applies *by `rfl`* to
  the `r • x` on each `scK₀.X_i`, since the `Module R scK₀.X_i` instance from
  `convert (e_i.toAddEquiv.module R)` is exactly `e_i.toEquiv.smul R`.
- **Result**: SUCCESS (mechanical). Three `h_mod_X_i` blocks now reference the
  hoisted handles.

#### Edit 2 — Close `f_R.map_smul'` and `g_R.map_smul'` via `Equiv.smul_def` + `e.injective` calc (raw log ~11:01:11 UTC, BasicOpenCech.lean L1015–1054)
- **Strategy** (for `f_R`): reduce
  `⇑(scK₀.f.hom) (r • x) = r • ⇑(scK₀.f.hom) x` to a deep claim
  `h_diff_pi_smul_f r (e₁ x)` via `Equiv.smul_def` + `e₂.injective`:
  ```lean
  intro r x
  have hkey := h_diff_pi_smul_f r (e₁ x)
  rw [LinearEquiv.symm_apply_apply] at hkey
  apply e₂.injective
  calc e₂ (⇑(ConcreteCategory.hom scK₀.f) (r • x))
      = e₂ (⇑(ConcreteCategory.hom scK₀.f) (e₁.symm (r • e₁ x))) := by congr 1
    _ = r • e₂ (⇑(ConcreteCategory.hom scK₀.f) x) := hkey
    _ = e₂ (r • ⇑(ConcreteCategory.hom scK₀.f) x) := by
        rw [show (r • ⇑(ConcreteCategory.hom scK₀.f) x : scK₀.X₂) =
              e₂.symm (r • e₂ (⇑(ConcreteCategory.hom scK₀.f) x)) from rfl,
            LinearEquiv.apply_symm_apply]
  ```
  `g_R.map_smul'` is the same proof at one cochain-degree shifted (uses
  `e₂/e₃` and `h_diff_pi_smul_g`).
- **Result**: SUCCESS (structural). Both iter-071 `map_smul'` sorries close;
  the substantive R-linearity of the alternating Čech differential is factored
  into two new helper sorries `h_diff_pi_smul_f` (L996) and `h_diff_pi_smul_g`
  (L1004).
- **Insight**: this pattern *converts an opaque R-linearity sorry into a
  product-representation R-linearity sorry*. The latter is much closer to
  Mathlib infrastructure (`Pi.map`, `LinearMap.pi_apply`) than the former.
  The next iteration's prover should be able to close `h_diff_pi_smul_{f,g}`
  by unfolding `alternatingCofaceMapComplex.d` and showing each
  `(C.left.presheaf.map _).hom` summand is an `R`-algebra-hom via the
  project-local `algebraMap_naturality` chain.

**Net for BasicOpenCech.lean**: 6 → 6 sorries (count unchanged; structural
transport closed; two iter-071 `map_smul'` sorries replaced by two helper
claims that decouple the `LinearMap`-structure obligation from the deep
R-linearity content).

---

## Solved targets summary

| File | Theorem | Status |
|---|---|---|
| `AlgebraicJacobian/AbelJacobi.lean` | `Jacobian.ofCurve` | RESOLVED (genus-0 = `toUnit`; genus>0 = witness projection) |
| `AlgebraicJacobian/AbelJacobi.lean` | `Jacobian.comp_ofCurve` | RESOLVED (`Subsingleton.elim` + witness projection) |
| `AlgebraicJacobian/Differentials.lean` | `Scheme.cotangentExactSeqAlpha` | RESOLVED (full `Derivation' φ_g'` construction) |

## Partial / structural

| File | Theorem | Sorry status |
|---|---|---|
| `AlgebraicJacobian/AbelJacobi.lean` | `Jacobian.exists_unique_ofCurve_comp` | 1 sorry (genus-0 existence — rigidity) |
| `AlgebraicJacobian/Jacobian.lean` | `JacobianWitness` / `nonempty_jacobianWitness` | structural refactor (`isAlbaneseFor : ∀ P, ...`); 1 sorry unchanged |
| `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` | `f_R.map_smul'`, `g_R.map_smul'` | structural transport closed; replaced by `h_diff_pi_smul_{f,g}` helper sorries |

---

## Key findings / patterns

1. **`unfold ... ; split_ifs with h` for `dite`-shaped definitions** *(NEW iter-072)*.
   When a definition is wrapped in `if h : P then ... else ...`, every
   downstream lemma reduces by case-split on `h`. The pattern is robust under
   `dsimp`-driven coercion fragility because the `unfold` happens before the
   `split_ifs`.
2. **Witness uniformity over the marked point: `isAlbaneseFor : ∀ P, IsAlbanese C P J`**
   *(NEW iter-072)*. Storing a family of Albanese predicates (one per `P`)
   inside the witness lets every consumer take its own `P` without reshaping
   the existence statement of the underlying scheme. Strict improvement over
   the iter-071 review's recommendation to parameterise the witness on `P`.
3. **`AddMonoidHom.mk'` + `Equiv.smul_def` chained transport** *(iter-072 BasicOpenCech)*.
   For an R-linear map between transported `Module R` structures, the smul
   compatibility reduces to: `apply e_target.injective; calc ... ; congr 1` (one
   step), then the deep claim on the explicit product representation. The
   `congr 1` step works *by `rfl`* because `e.toEquiv.smul` is exactly the
   underlying `Module R` instance after `convert`.
4. **Adjunction-coherence is `rfl` for composed pullback adjunctions** *(iter-072 Differentials)*.
   The identity `φ_g' ≫ f.c = adj_f.unit.app _ ≫ (pushforward f.base).map φ_fg'`
   is definitional; reusable any time we transport a derivation across
   `pushforward f ∘ pushforward g = pushforward (f ≫ g)`.
5. **Helper-claim factorisation for opaque transport sorries** *(iter-072 BasicOpenCech)*.
   When a sorry hides both *structural transport* and *deep mathematical content*,
   factoring the transport into a clean calc and pushing the deep content into
   a labelled `have` hypothesis is strictly better than a single bare `sorry`,
   even if the count stays the same.
6. **Patterns retained from prior iterations**:
   - Single-witness consolidation *(iter-071, Jacobian.lean)*
   - `toFun := ⇑(ConcreteCategory.hom f); map_add' := map_add _` *(iter-071, BasicOpenCech.lean)*
   - `localizedModuleIsLocalizedModule` one-liner *(iter-071, BasicOpenCech.lean)*
   - `refine ⟨?_, ?_, ?_⟩` 3-case decomposition *(iter-071, Differentials.lean)*
   - `ModuleCat.piIsoPi + e.toAddEquiv.module R` transport *(iter-069)*
   - Adjunction-then-universal-property skeleton *(iter-069 + iter-071, now applied iter-072)*
   - Genus-0 terminal-object discharge *(iter-069)*

---

## Recommendations for next session
See `recommendations.md`.

---

## Blueprint markers updated (manual)
None this iteration. No `\notready` markers exist; no `\mathlibok` markers were
warranted (no Mathlib re-exports in this iteration); no provers reported a
`\lean{...}` rename. The deterministic `sync_leanok` phase will manage the
`\leanok` placement on `def:cotangent_alpha` (now sorry-free in the body) and on
the three `AbelJacobi.tex` blocks (`def:ofCurve`, `lem:comp_ofCurve` proof block,
`thm:exists_unique_ofCurve_comp` statement block). One known structural gap
flagged by the BasicOpenCech prover: the prover task header references a
`AlgebraicJacobian_Cohomology_BasicOpenCech.tex` chapter that does not exist
in the blueprint tree — the actual content lives under
`Cohomology_MayerVietoris.tex`. Reconciliation belongs to the plan agent (the
review agent must not edit informal prose or chapter structure).
