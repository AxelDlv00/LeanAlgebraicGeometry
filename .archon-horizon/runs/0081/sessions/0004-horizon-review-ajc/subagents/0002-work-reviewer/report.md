Clean — no files edited, no probe files left. All six answers are measured at kernel level.

## VERDICT: the migration is REAL but only PARTIAL — and it is the headline's dimension obligation that is stranded

Not churn, not fake progress. The étale rewire genuinely moved the headline off the rational point: `Jacobian`, `jacobianWitness`, `nonempty_jacobianWitness` and `picardJacobianWitness` carry **no gate binder at all**, and `Pic0Et` re-proves four attributes unconditionally. But `HasPicSchemeEt` **replaced `HasPicScheme` only in the four abelian-variety attributes**. The tangent-space and dimension development — 54 of the 76 sites, the machinery that *produces the number `genus C`* — was never ported, which is why the headline's own dimension theorem is a bare `sorry`.

Method note, since the earlier 90/75 disagreement is what prompted this: both numbers were wrong, and text alone cannot settle it. I measured twice, independently, and they agree exactly.

**Method A (source).** A Lean-aware comment stripper (nested `/- -/`, `/-- -/`, `--`, string and char literals, blanked to spaces to preserve offsets), then occurrences attributed to the *enclosing declaration*, counting only bracketed `[...]` groups. Validated by showing it removes declaration-keyword lines that raw grep counts inside docstrings.
**Method B (kernel).** `lake build AlgebraicJacobian` (EXIT=0, 8851 jobs), then `forallTelescopeReducing` over every `ConstantInfo.type`, counting a declaration iff some binder has `binderInfo == .instImplicit` **and** its type mentions the target constant. Prose is structurally invisible here.

### 1. `[HasPicScheme C]` instance binders in code: **76 declarations, 8 files**

| file | decls |
|---|---|
| `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` | 34 |
| `AlgebraicJacobian/Picard/IdentityComponent.lean` | 14 |
| `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` | 9 |
| `AlgebraicJacobian/Picard/Pic0Dimension.lean` | 6 |
| `AlgebraicJacobian/Picard/GroupSchemeHomogeneity.lean` | 5 |
| `AlgebraicJacobian/Jacobian.lean` | 4 |
| `AlgebraicJacobian/Picard/HomogeneityOrbitCollapse.lean` | 2 |
| `scripts/axiom-frontier.lean` | 2 |

Kernel agrees: 86 hits − 12 auto-generated (`.mk/.rec/.recOn/.casesOn/.eq_1` and the `.has_pic_scheme` projection) = 74, +2 in `scripts/axiom-frontier.lean` (outside the import root) = **76**.

**How prose was excluded, and what it cost.** Raw grep gives **94** lines in **11** files. **18 lines in 3 whole files** are docstring prose: `Albanese/AlbaneseUP.lean` (4), `Picard/FGAPicRepresentability.lean` (5), `Jacobian.lean` (3), `scripts/axiom-frontier.lean` (2), `GroupSchemeHomogeneity.lean` (1), `Pic0AbelianVariety.lean` (1), `Pic0DualNumberCocycle.lean` (1), and — neatly — `Pic0Et.lean` (1). AlbaneseUP, Pic0DualNumberCocycle and Pic0Et are **prose-only**: they appear in the 10/11-file counts but bind nothing. The 75-vs-76 gap is one anonymous `instance {k : Type u} ...` at `FGAPicRepresentability.lean:999`, which a name-based scan drops. There are **no `variable`-line binders**, so every site sits on a declaration signature.

### 2. `[HasPicSchemeEt C]`: **15 declarations, 2 files** — `Picard/Pic0Et.lean` 10, `Picard/FGAPicRepresentability.lean` 5. Here raw grep also gives 15: no prose contamination. Kernel: 16 − 1 projection = 15.

### 3. Instances of `HasPicScheme`: **ZERO.** Kernel enumeration over `isInstanceCore` with the conclusion head matching the class returns **0**. `example : Scheme.HasPicScheme C := by infer_instance` at the three challenge binders fails with `synthInstanceFailed`. The **single producer project-wide** is a theorem, not an instance:

`AlgebraicJacobian/Picard/FGAPicRepresentability.lean:562` — `theorem picSchemeOfHasRationalPoint`, hypotheses `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom] [HasRationalPoint C]`, body resting on the `sorry` at `:406` (`fgaPicardRepresentability`). Index-confirmed, so nothing `private` or misplaced is hiding. (`instHasPicScheme` exists only in the *sibling* projects Albanese and Picard-IdentityComponent — a cross-project name collision, not this project.)

### 4. Reachability — **one correction to the premise of the task.** `HasPicScheme` is *not* unreachable. It is unreachable **over an arbitrary field**, but inhabited over an algebraically closed one, and that route is live: `AlbaneseUP.lean:289 hasRationalPoint_of_isAlgClosed` `[IsAlgClosed kbar] [Smooth] [GeometricallyIrreducible]` → `Jacobian.lean:377 hasRationalPoint_of_curve_of_isAlgClosed` → `picSchemeOfHasRationalPoint`. I compiled it: naming that chain at `[IsAlgClosed k]` produces `HasPicScheme C` with no error. The only *instance* producing `HasRationalPoint` is `CurveBaseChange.lean:285 hasRationalPoint_baseChangeField`, which needs `[HasRationalPoint C]` already — it propagates, never creates. So: no unconditional producer over general `k`; a genuine one over `k̄`. The 76 results are about **pointed curves**, not about no curve.

### 5. Headline results carrying the plain binder (`Challenge.lean` does not exist in this project):

- `AlgebraicJacobian/Jacobian.lean:390` `smoothOfRelativeDimension_genus_pic0`
- `:481` `finrank_tangentSpace_pic0_eq_genus`
- `:511` `isAlbanese_pic0`
- `:588` `isAlbanese_pic0_of_isAlgClosed`

Plus all 34 of `Pic0AbelianVariety` (through `Pic0.isAbelianVariety`, `smooth`, `proper`, `tangentSpaceIso`) and all 14 of `IdentityComponent`'s degree machinery. These are conditional-on-a-section, correctly labelled as such in their docstrings, and `picardJacobianWitnessOfHasRationalPoint` / `picardJacobianWitnessOfIsAlgClosed` are explicitly marked not-the-headline.

### 6. Replaced, or merely beside it? **Beside it. Evidence both ways.**

Migrated: the headline routes `picardJacobianWitness` → `Pic0SchemeEt`; `instHasPicSchemeEt` is unconditional; `Pic0Et` proves `grpObj`, `geometricallyIrreducible`, `locallyOfFiniteType`, `isSeparated` outright, leaving 2 sorries (`geometricallyReduced:170`, `universallyClosed:223`).

Not migrated: `Pic0SchemeEt` reaches **3 files**; `Pic0Scheme` spans **8**. **No** étale counterpart exists for the tangent-space chain (`tangentSpaceIso`, `finrank_cotangentSpace_eq_finrank_hModuleOne`, `semilinearComparison_cotangentSpaceDual_h1Cok`, `pointedDualNumberPoints_equiv_*`), for `Pic0Dimension` (6), for `GroupSchemeHomogeneity` (5), or for the degree machinery (`classOfSection`, `degreeOfSection`, `ClassDegree`, `finrank_eq_genus`, `kPoints_iff_kerDegree`).

**The cost is concrete, not cosmetic.** `Jacobian.lean:424 smoothOfRelativeDimension_genus_pic0Et` is a **bare `sorry`**, while its twin `:390 _pic0` is backed by the landed tangent-space chain — the Et tower has no dimension count, and the missing 54 sites are exactly what would supply it. Same shape at `:541 isAlbanese_pic0Et` (bare `sorry`) vs `:511 isAlbanese_pic0`.

### Both classes bound by one declaration: **NONE**

Zero declarations bind both. So this is not a half-edited signature problem — it is two disjoint towers of very unequal size, which is a cleaner state to be in but makes the 54 unported sites a deliberate decision someone still owes.

### Other finding worth the owner's attention

`scripts/axiom-frontier.lean` still names `instHasPicScheme` as a live, sorry-bodied, **synthesised** gate at lines 86, 415, 447, 497, 538, 1206. Two are load-bearing: `:447` is the header justifying the file's five-not-four obligation count, and `:415`/`:456` build a clean/leak contrast on "assumed vs *synthesised*". Nothing is synthesised on either side any more. The count (five) and the leak both survive — `probe_pic0Scheme_named_of_isAlgClosed` still reports `sorryAx` because it *names* the theorem — but the stated reason is defunct. `TO_USER.md:37`, `Jacobian.lean:372` and `README.md:77` all already carry the corrected wording; it did not reach the one file the project tells readers to run before believing any completeness number.

Filed: **I-0934** (stale `instHasPicScheme` prose in the probe), **I-0938** (incomplete migration, 76 vs 15, stranded dimension chain), **I-0940** (memory: count binder sites in the built environment, not with grep).
