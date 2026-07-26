## Audit findings

### 1. `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataCharts.lean`

Docstring "## Main declarations" (lines 18–39). File is `namespace AlgebraicGeometry` (59) with inner `section Charts` (105–225) — no inner namespace, so bullet prefix `AlgebraicGeometry.` resolves directly.

| Bullet name | Verdict |
|---|---|
| `AlgebraicGeometry.JacobianData.ofRepresentableBy` | FOUND — line 71 |
| `AlgebraicGeometry.gluedHom` | FOUND — line 122 (`noncomputable abbrev`) |
| `AlgebraicGeometry.gluedOfCharts` | FOUND — line 129 (`noncomputable abbrev`) |
| `AlgebraicGeometry.chartHom` | FOUND — line 114 |
| `AlgebraicGeometry.toGlued_comp_gluedHom` | FOUND — line 141 |
| `AlgebraicGeometry.locallyOfFiniteType_gluedHom` | FOUND — line 154 |
| `AlgebraicGeometry.quasiCompact_gluedHom` | FOUND — line 164 |
| `AlgebraicGeometry.JacobianData.ofCharts` | FOUND — line 182 |

**8/8 bullets accurate.** Prose-referenced cross-file names also real: `pic0RepresentableByOfCharts` (`Picard/Pic0SigmaSheaf.lean:161`), `pic0SigmaFunctor_isSheaf` (same file, :90), `pic0TypeFunctor` (same file, :58).

Total top-level declarations: **16** (+1 `example` at line 237). Existing but NOT in the docstring bullets:
- `JacobianData.ofChartsOfCompactSpace` (line 209) — **significant omission.** Its own docstring says "This is the form the classical construction needs" and the "What remains" section (lines 266–273) argues the finite-index `ofCharts` is *not* the usable producer. The bullet list advertises only `ofCharts`.
- `representableBy_homEquiv_toGlued` (133), plus simp lemmas `ofRepresentableBy_J` (81), `ofRepresentableBy_rep` (88), `homEquiv_ofRepresentableBy` (96), `ofCharts_J` (192), `ofChartsOfCompactSpace_J` (219).

### 2. `.../AlgebraicJacobian/Picard/DivRepGlobalClassify.lean`

Docstring "The results:" bullet list (lines 30–38). Namespace nesting: `AlgebraicGeometry` (50) → `section Curve` (85) → `namespace DivRepAffinePullback` (118–310). So bullets qualified `AlgebraicGeometry.DivRepAffinePullback.X` correspond to bare `X` declared at line ≥ 118 — resolved accordingly.

| Bullet name | Verdict |
|---|---|
| `AlgebraicGeometry.DivRepAffinePullback.classifyGlobal` | FOUND — line 200 (`def classifyGlobal`, inside `namespace DivRepAffinePullback`) |
| `AlgebraicGeometry.DivRepAffinePullback.toGlobalData` | FOUND — line 284 |
| `AlgebraicGeometry.DivRepAffinePullback.representableBy` | FOUND — line 302 |
| `fromSpecAffine_classifyGlobal` (parenthetical in bullet 1) | FOUND — line 228 |

**3/3 bullets (4/4 incl. parenthetical) accurate.** Prose cross-refs also real: `DivRepAffinePullback.equiv` → `Picard/DivRepAffKit.lean:193` inside `namespace DivRepAffinePullback` (188) — correct qualification, not the same-named `DivRepGlobalData.equiv` at `DivRepKit.lean:84`. Also `pull_naturality` (`DivRepAffKit.lean:184`, structure field), `pullGlobal`/`pullGlobal_val`/`pullGlobal_comp` (`DivRepGlobalLift.lean:102/115/132`), `DivRepGlobalData` (`DivRepKit.lean:68`), `DivRepGlobalData.representableBy` (`DivRepKit.lean:113`).

Total top-level declarations: **14**, of which **8 are `private`** (64, 72, 127, 146, 155, 176, 184, 211) and 6 public. Public but not bulleted:
- `pullGlobal_classifyGlobal` (line 248) and `classifyGlobal_pullGlobal` (line 265) — the two inverse laws. Named only in the prose of `toGlobalData`'s own doc comment, not in the top-level results list. Minor under-advertising, not a false claim.

### 3. `.../AlgebraicJacobian/Curve/P1Aut.lean`

**File exists** (5368 bytes). Module docstring is lines 8–12: title `# Automorphisms of the projective line: the GL₂-twist` + "Work in progress." — **no "Main declarations"/"Main definitions"/"Main results" bullet list at all**, so nothing to falsify.

Content note (factual, not a docstring-bullet violation): the file declares **13** top-level declarations and none of them is an automorphism of `P¹`. Namespaces: `MvPolynomial` (20–106) — `matrixLinearForm` (28), `matrixLinearForm_mem` (32), `substAlgHom` (39), `substAlgHom_X` (44), `substAlgHom_mem` (49), `substGradedHom` (59), `substGradedHom_apply` (65), `substAlgHom_mul` (71), `substGradedHom_mul` (81), `substAlgHom_one` (91), `substGradedHom_one` (98); `AlgebraicGeometry` (108–146) — `irrelevant_le_map_of_rightInverse` (121), `Proj.map_congr` (140). The title over-promises relative to content, but it is explicitly flagged "Work in progress."

Note: `AlgebraicJacobian.Curve.P1Aut` is **not imported** by `AlgebraicJacobian.lean`, so it is not elaborated by a bare `lake build`. The other two files are imported (root lines 240 and 421).

### 4. README — `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md`

All named Lean declarations exist, all in `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean`:

| README name | Verdict |
|---|---|
| `genus` | FOUND — Challenge.lean:89 (`AlgebraicGeometry.genus`) |
| `Jacobian` | FOUND — :96 |
| `ofCurve` | FOUND — :125, inside `namespace Jacobian` (101–160) → `AlgebraicGeometry.Jacobian.ofCurve` |
| `exists_unique_ofCurve_comp` | FOUND — :141, same namespace |
| `Jacobian.functor` | FOUND — :153 (`functor` inside `namespace Jacobian`) |
| `baseChangeIso` | FOUND — :244, inside second `namespace Jacobian` (228–285) |
| `baseChange_ofCurve` | FOUND — :278, same namespace |

Paths/structure claims — all verified present: `AlgebraicJacobian/Challenge.lean`, `AlgebraicJacobian/`, `AlgebraicJacobian.lean`, `blueprint/` (contains `src/`, `lean_decls`), `archon-protected.yaml`, `../../references/manifest.yaml`, `../../.lake-packages`, sibling `MainProjects/Algebraic-Jacobian-Challenge`.

Quantitative claims verified:
- "house limit 500 lines per file, currently exceeded by 14 files tracked in inbox `I-0220`" — **exactly 14** files exceed 500 lines (largest: `Cohomology/RelCurveCollapse.lean` 752, `Picard/DivSchemeHighWindowFibreNormalization.lean` 721, `Picard/EntryIdeal.lean` 634). Inbox item `I-0220` exists under `/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/inbox/`. Accurate.
- "`lake build`'s default target is this module" — confirmed in `lakefile.toml`: `defaultTargets = ["AlgebraicJacobian"]`.
- Its own caveat about unimported files is materially understated in practice: **624** `.lean` files exist under `AlgebraicJacobian/` but the root imports only **499**, so **125 modules are not elaborated by a bare `lake build`** (including `Curve/P1Aut.lean`). The README states the mechanism correctly but gives no sense of the scale.

One dangling reference outside the README: every file header says "as described in the file LICENSE", but there is **no `LICENSE` file** in the project root.

### Bottom line
No I-0349-style phantom bullets in these three files. `JacobianDataCharts.lean` (8/8) and `DivRepGlobalClassify.lean` (3/3 + 1) are fully backed by real declarations, with correct namespace qualification in both cases (including the `DivRepAffinePullback.equiv` vs `DivRepGlobalData.equiv` distinction, which resolves correctly). `P1Aut.lean` has no bullet list. The README's declaration and path claims all check out. The residual issues are omissions rather than fabrications: `JacobianData.ofChartsOfCompactSpace` is unadvertised despite being the producer the file's own prose says is needed, and the README's "not elaborated until imported" caveat hides a 125-file gap.
