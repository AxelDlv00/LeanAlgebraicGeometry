All five items filed (I-0703 through I-0707).

# Review: `ajcr-divrep`, run 0071 session 0010

## Verdict: CHURNING, with one sound result

Three commits, two new Lean files (447 lines), one real bug fix, one doc section. The bug fix is genuine and valuable. But the session's headline — "U2's residue is now EXACTLY ONE statement" — is not supported, and the two `DivFamZar` endpoints it built are unusable as written. Nothing produces a certificate, no gate cleared; the session itself says so, which is honest. What it is not honest about is the *size* of the residue, and the round is the third in a row that re-describes U2 instead of discharging it (s0006 "U2 is an equation", s0008 "one certificate plus one scalar", s0010 "both inputs were artefacts").

## (A) Claim 2 is a valid reduction of the ε layer, but the endpoints throw the payload away

The mathematical core is right. `divisorWindow` reads only `d` (`DivisorFamilyWindow.lean:103`), `divisorWindow_eq_of_le_of_isCertified` (`DivSchemeEps.lean:196`) does quantify over an arbitrary `A`, and `CertifiedDivisorFamily` (`DivisorFamily.lean:452`) is a triple. `certifiedFamilyOfAdaptation` and `divFamEps_certifiedFamilyOfAdaptation` are a faithful de-`choose`ing of `certifiedFamily` / `divFamEps_certifiedFamily`. No coherence requirement is broken, because I found **no consumer at all** — `divFamZarUniv`, `divFamZarUnivOfNeZero`, `divFamZarUnivOfHasCertifiedAdaptation` have zero references outside their own three files.

The defect is at the endpoints:

```
noncomputable def divFamZarUnivOfHasCertifiedAdaptation ... : DivFamZar C RZ pi g :=
  DivFamZar.mk (exists_divFamZar_... hca).choose.eqns
               (exists_divFamZar_... hca).choose.isLocallyCertified
```

`DivFamZar` is a quotient by `DivEq` and `divFamEps` is typed on `DivFam`, not `DivFamZar`. So the class carries no ε-value, and no lemma recovers it. The file's own docstring diagnoses this precisely — "a class without its ε-value does not serve `isChartClause_iff_forall_classify_eq`" — and then defines exactly that. §7.11.2 removed a `Classical.choose` on the adaptation and §7.11.2's endpoint added one on the family. Filed as **I-0703**.

## (B) Not vacuous — the sharper risk is that it is refutable

`HasCertifiedAdaptation` is not trivially satisfiable: `IsCertified` (`DivisorFamily.lean:426`) is seven substantive clauses, and `n = 0` does not degenerate it in a useful way. The real problem is the opposite. In the same run, sibling lane `ajcr-cert-r2` landed

```
forall_not_isCertified_of_straddling :   -- DivisorFamilyAffStrict.lean:127
  ∀ (A : DivisorAdaptation C R pi d) (n : ℕ), ¬ A.IsCertified n
```

for a connected divisor with a support point off `V₀` and one off `V₁`. That is the negation of `HasCertifiedAdaptation` **at the same binder** — and it is the entire content of the R2 widening the human mandated in I-0492. If the high-window universal seed's `localEquations` is in that class, the new residue is false, not open, and §7.11.3's table prices an unsatisfiable statement as "the whole critical path."

Nobody has crossed the two. I grepped: no file measures `supportLocus` of the universal seed against `V₀`/`V₁`. That is a one-grep decision procedure for whether the roadmap row is live or dead, and it should be the next session's first action. Filed as **I-0705**; the transferable form as memory **I-0707**.

## (C) Claim 1 is sound; its scope note is not

`windowBound_pos_of_genus_ne_zero` is correct and the instantiation at `Y = C.left`, `K = k` is legitimate — `WindowLedgerF3`'s instance block is a subset of what `UnivFree.lean` has in scope, and `hO`/`hchi` match. `WindowLedgerF3` does use the same disjunction twice already.

What I reject is "`g = 0` being the case where `Pic⁰` is trivial" (`UnivFree.lean:35`). `Challenge.lean:89` defines `genus` as a bare `finrank H¹` with no `g ≠ 0` guard, and grepping `g = 0` / `genus_eq_zero` across `Picard/` returns only this session's own two files. The `g = 0` branch is handled nowhere. `hb` was not eliminated — it was renamed to `hg` and deferred to a consumer who cannot currently supply it. Fine as a reduction; wrong as "not an obligation." Filed in **I-0706**.

## (D) Verification language: honest, unusually so

§7.11.4 and the roadmap row both state plainly that this is standalone elaboration against built oleans, **not** a `lake build`, that the modules are unrooted, and that two builds died. I confirmed: no `.olean` exists for any of the three, and `AlgebraicJacobian.lean` imports only `DivRepChartRange`. I found no sentence a reader would take as "kernel-checked module." This is the one axis where the session over-delivered on rigour.

## (E) Advertised-but-absent: clean

All 31 declaration names cited in the three files' docstrings and §7.11 exist. Line numbers are accurate except three off-by-small (`WindowLedgerF3` `:91→87`, `:106→102`, `DivisorFamilyWindow` `:101→103`) — cosmetic, all resolve to the right declaration.

## Claim 3: confirmed, and it is the session's best work

`DivisorAdaptation.IsCertified.thetaGluedEval_surjective` does have `C`, `π`, `hπ` explicit and preceding `hc` — I checked the elaborated signature directly. The dot-notation spelling fed `hO` into the `C` binder. This was a real error in a file committed unverified the previous session, and no sorry census would have caught it. The fix is correct in both `DivRepChartClassUniv.lean:179-182` and `DivRepChartClassUnivAny.lean:144-147`.

## Claim 4: under-priced

"One type mismatch; re-typing the ε layer is cheaper than it looks" understates the work. Of ~30 `Picard/DivisorFamilyAff*.lean` files, **zero** mention `ThetaGlued` or `thetaGluedEval`. The ε layer needs `A.ThetaGlued` / `A.thetaGluedEval` (`DivisorFamilyTheta.lean:232,311`) plus the surjectivity engine, whose inputs `LiftsOnChart₀`/`LiftsOnChart₁` (`DivisorFamilyThetaSurj.lean:97,105`) are stated at the two pinned charts over `FinCoverData`'s `Fin m₀ ⊕ Fin m₁` index, which `AffCoverData` does not have. That is roughly six files plus a chart-free replacement of the lifting inputs. `AffFraming`'s `eps` only shows that `divFamEps` (which reads `eqns`) transports — not the theta layer the *certificate* consumes. Filed in **I-0706**.

## Files

- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivRepChartClassUnivAny.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivRepChartClassUnivFree.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivRepChartClassUniv.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivisorFamilyAffStrict.lean` (the colliding no-go)
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivRepChartRange.lean` (what U2 actually is)
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/informal/w4-rep-critical-path.md` §7.11

Inbox: **I-0703**, **I-0704**, **I-0705**, **I-0706** (issues), **I-0707** (memory).
