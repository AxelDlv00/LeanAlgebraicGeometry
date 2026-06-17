# Session 1 — Discovery iteration (prover stage)

## Metadata
- **Session number:** 1 (iteration 001 in `.archon/logs/iter-001/`)
- **Stage:** prover (discovery sub-stage per `STRATEGY.md` and `PROGRESS.md`)
- **Sorry count before:** 9 (1 + 5 + 3 across the three protected files)
- **Sorry count after:** 9 (no closure expected; iteration 0 is discovery)
- **Files edited this session:** `AlgebraicJacobian/Jacobian.lean` (3 Edits — module docstring + per-sorry comment blocks), `AlgebraicJacobian/Genus.lean` (1 full Write — discovery docstring + commented sketch). `AbelJacobi.lean` was not edited.
- **Targets attempted:** all 9 protected declarations.
- **Models:** three parallel prover agents, model `claude-opus-4-7` each (per `provers-combined.jsonl`).
- **Compilation:** all three files compile (only `sorry` warnings; 0 errors; verified via `lean_diagnostic_messages` after the edits).

## Per-target outcomes

### `AlgebraicGeometry.genus`  (Genus.lean L87) — BLOCKED
Prover did the most aggressive constructive attempt: sketched
`OXAsAddCommGrpSheaf C := ⟨C.left.sheaf.1.comp (forget₂ CommRingCat RingCat ⋙ forget₂ RingCat AddCommGrpCat), sorry⟩`
inside the docstring. `lean_run_code` confirmed two sanity facts:
1. `TopCat.Sheaf C X = Sheaf (Opens.grothendieckTopology X) C` is definitional (`rfl`).
2. The composite forget functor `CommRingCat ⥤ RingCat ⥤ AddCommGrpCat` type-checks.

But the sheaf condition cannot be propagated automatically: there is no
`HasSheafCompose` instance for that composite on `Opens.gT X`. The
Mathlib chain therefore breaks at step 1 of the five-step gap chain
documented in `task_results/Genus.md`:
1. `HasSheafCompose` for the forget composite.
2. `HasSheafify (Opens.gT X) AddCommGrpCat`.
3. `HasExt (Sheaf (Opens.gT X) AddCommGrpCat)`.
4. The bridge `Scheme.structureAddCommGrpSheaf : Scheme → Sheaf … AddCommGrpCat`.
5. The `Module k` structure on `Sheaf.H _ 1` from `C.hom`.

22+ search queries (`lean_local_search` for `Scheme.cohomology`,
`QuasiCoherent`, `RightDerived`, `finrank H1`; `lean_leansearch` for
"sheaf cohomology of structure sheaf of scheme", "Kaehler differentials
scheme cotangent", etc.) confirmed the gap. The only sheaf-cohomology
file in `AlgebraicGeometry/` is `Sites/EllAdicCohomology.lean` (étale
ℓ-adic — wrong theory).

`Module.finrank` itself returns 0 without finite-dimensionality, so the
type-check blocker is step 4, not step 5 (Serre's theorem); but step 5
remains needed for downstream theorems like
`smoothOfRelativeDimension_genus`.

### `AlgebraicGeometry.Jacobian` and the four instances (Jacobian.lean L77, 88, 97, 104, 114) — BLOCKED
- `lean_local_search` on each of `PicardScheme`, `PicardFunctor`, `Pic0`,
  `Scheme.Pic`, `Scheme.Picard`, `LineBundle`, `InvertibleSheaf`,
  `InvertibleModule`, `AbelianVariety`, `AbelianScheme`,
  `ProperGroupScheme`: 0 hits. `lean_local_search "Pic"` returned the
  unique hit `CommRing.Pic`.
- `lean_loogle "CommRing.Pic"`: 8 hits, all confined to
  `Mathlib/RingTheory/PicardGroup.lean` (rings only).
- Direct inspection of `Mathlib/AlgebraicGeometry/Group/`: exactly two
  files (`Abelian.lean`, `Smooth.lean`). Only theorems present:
  `isCommMonObj_of_isProper_of_isIntegral_tensorObj_of_isAlgClosed`
  (Stacks 0BFD — commutativity) and
  `smooth_of_grpObj_of_isAlgClosed` (smoothness of reduced
  locally-finite-type group scheme over alg-closed field). Neither
  yields `GrpObj` on `Pic⁰` nor a relative-dimension formula.

The forbidden shortcut `Jacobian C := 𝟙_ (Over (Spec (.of k)))` was
explicitly analysed: three of the four instances discharge trivially
(`instGrpObj` via `instTensorUnit`, `instIsProper` since `𝟙` is proper,
`instGeometricallyIrreducible` since `Spec k` is geometrically
irreducible), but `smoothOfRelativeDimension_genus` becomes
`SmoothOfRelativeDimension (genus C) (𝟙 (Spec (.of k)))`. The identity
morphism is smooth of relative dimension 0 with no other honest witness,
so closure forces `genus C = 0` — false in genus ≥ 1. The prover
documented this in-file (in the module docstring) and in
`task_results/Jacobian.md`.

The five sorries collapse to a single Phase-C representability theorem
(`thm:Pic_representable` in the blueprint). The prover's recommended
next-iteration target is **Step 1: `AlgebraicGeometry.Scheme.LineBundle`
+ `CommGroup` instance** — the smallest self-contained helper, no
cohomology dependency.

### `AlgebraicGeometry.Jacobian.ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp` (AbelJacobi.lean L34, 40, 49) — BLOCKED
- All three structurally depend on `Jacobian C`, itself blocked.
- `lean_local_search` on `rigidity`, `Albanese`, `AbelJacobi`,
  `AbelianVariety`, `Pic`, `Picard`, `LineBundle`, `InvertibleSheaf`,
  `universalProperty`, `GrpObj.hom`, `GrpObj.commute`,
  `isProperCommGroup`, `geometricallyIntegralGroupComm`,
  `AlgebraicGeometry.Group`: all empty except
  `Pic` → `CommRing.Pic`.
- `lean_leansearch` on "rigidity theorem morphism abelian variety",
  "Albanese variety universal property", "Picard scheme of a curve",
  "morphism vanishing on open subset is zero proper irreducible",
  "image of curve generates Jacobian symmetric power",
  "Mumford rigidity": all top-5 results unrelated.
- Direct read of `Mathlib/AlgebraicGeometry/Group/Abelian.lean`:
  confirmed only Stacks 0BFD, no rigidity.

The prover identified **Helper H1: rigidity for morphisms of abelian
varieties** (`AlgebraicGeometry.GrpObj.eq_of_eqOnOpen`) as the
highest-leverage standalone target — independent of `Jacobian C`,
provable from current Mathlib alone, and unlocks the uniqueness half of
`exists_unique_ofCurve_comp`. Three further Helpers (H2 existence
template, H3 universal-property closure, H4 generation) are stated in
`task_results/AbelJacobi.md`.

The forbidden shortcut `ofCurve P := toUnit C ≫ η[Jacobian C]` was
explicitly analysed: it makes `comp_ofCurve` trivial but falsifies
`exists_unique_ofCurve_comp` for any non-constant pointed
`f : C ⟶ Jacobian C`, which exists in genus ≥ 1.

## Key findings / proof patterns discovered

1. **The 9 protected sorries collapse to ~3 missing Mathlib chapters.**
   Genus → Phase A (coherent cohomology). Jacobian + 4 instances → Phase
   B/C (line bundles, Picard scheme, connected component of identity).
   AbelJacobi → Phases C/E (Pic⁰ universal property + rigidity).
2. **One standalone target unlocks one half of one sorry.** Helper H1
   (rigidity, in `task_results/AbelJacobi.md`) is the unique
   sorry-blocking helper provable from current Mathlib alone. Every
   other helper requires upstream infrastructure not yet built.
3. **The "trivial-Jacobian" shortcut is mathematically (not
   stylistically) forbidden.** Documented in-file and in two task
   result files; the obstruction is `genus C = 0`, false in positive
   genus.
4. **The four Jacobian instances are joint corollaries of one
   representability theorem.** This confirms `PROGRESS.md` objective
   2.iii. Once Phase C lands, all four are 1-line `inferInstance`
   calls.
5. **`Mathlib/AlgebraicGeometry/Group/Abelian.lean` is the *only*
   pre-existing AG-side abelian-variety theorem in Mathlib b80f227.**
   It gives commutativity (Stacks 0BFD) but not rigidity, biduality,
   dual abelian variety, or universal property of Pic⁰.
6. **`TopCat.Sheaf C X = Sheaf (Opens.grothendieckTopology X) C` is
   definitionally true** (verified via `rfl` in `lean_run_code`). This
   means the abstract `Sheaf.H` cohomology API is reachable from the
   structure sheaf if the missing instance chain is wired.

## Blueprint markers updated

For each protected declaration whose Lean signature exists and whose
file compiles (with `sorry` body), the statement block was given
`\leanok`. No proof block received `\leanok` (every protected
declaration has at least one `sorry`). Supporting blocks
(`def:Pic_functor`, `thm:Pic_representable`) without a Lean counterpart
were left unmarked with a `% NOTE:` flag.

- `Genus.tex`, `def:genus` — added `\leanok` in `\begin{definition}` block
  (Lean decl `AlgebraicGeometry.genus` exists at L87 of `Genus.lean`,
  file compiles with 1 sorry warning, 0 errors).
- `Jacobian.tex`, `def:Pic_functor` — left unmarked, added `% NOTE:`
  (no Lean counterpart yet — Phase C step 2).
- `Jacobian.tex`, `thm:Pic_representable` — left unmarked, added `% NOTE:`
  (no Lean counterpart yet — Phase C step 4; bundles 5 protected
  declarations).
- `Jacobian.tex`, `def:Jacobian` — added `\leanok` in `\begin{definition}`
  (Lean decl `AlgebraicGeometry.Jacobian` exists at L68 of
  `Jacobian.lean`, file compiles with 5 sorry warnings, 0 errors).
- `Jacobian.tex`, `thm:Jacobian_grpObj` — added `\leanok` in
  `\begin{theorem}` (decl `AlgebraicGeometry.Jacobian.instGrpObj` exists
  at L85).
- `Jacobian.tex`, `thm:Jacobian_smooth_genus` — added `\leanok` in
  `\begin{theorem}` (decl
  `AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus` exists at
  L92).
- `Jacobian.tex`, `thm:Jacobian_proper` — added `\leanok` in
  `\begin{theorem}` (decl `AlgebraicGeometry.Jacobian.instIsProper`
  exists at L100).
- `Jacobian.tex`, `thm:Jacobian_geomIrred` — added `\leanok` in
  `\begin{theorem}` (decl
  `AlgebraicGeometry.Jacobian.instGeometricallyIrreducible` exists at
  L107).
- `AbelJacobi.tex`, `def:ofCurve` — added `\leanok` in
  `\begin{definition}` (decl `AlgebraicGeometry.Jacobian.ofCurve` exists
  at L34 of `AbelJacobi.lean`, file compiles with 3 sorry warnings, 0
  errors).
- `AbelJacobi.tex`, `lem:comp_ofCurve` — added `\leanok` in
  `\begin{lemma}` only (decl exists at L39); proof block left
  *without* `\leanok` because the body is `sorry`.
- `AbelJacobi.tex`, `thm:exists_unique_ofCurve_comp` — added `\leanok`
  in `\begin{theorem}` only (decl exists at L49); proof block left
  *without* `\leanok` because the body is `sorry`.
- No `\lean{...}` macro changes — every protected declaration is at the
  exact name the blueprint already cites.
- No `\notready` markers existed before this session; none added (the
  active vocabulary is only `\leanok` / `\mathlibok` per the
  conventions).

## Recommendations for next session

See `recommendations.md` for the full plan-agent briefing. In short:
1. Issue Helper H1 (rigidity for morphisms of abelian varieties) as a
   standalone target in a new file (`AlgebraicJacobian/Rigidity.lean`).
2. In parallel, begin Phase A step 1: `HasSheafCompose` instance for the
   `CommRingCat → AddCommGrpCat` forget composite on `Opens.gT`.
3. In parallel, begin Phase B/C step 1: `Scheme.LineBundle` + tensor
   product `CommGroup` instance.
