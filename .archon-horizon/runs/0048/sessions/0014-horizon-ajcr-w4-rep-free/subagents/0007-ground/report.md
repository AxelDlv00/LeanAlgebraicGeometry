Review complete. Four inbox items filed (I-0366 through I-0370, five actually). Findings below.

---

# Ground review — run 0048 round 5, `ajcr-w4-rep-free`

## URGENT, do this before anything else

The shared ledger index is staged to **revert the entire round**.

```
D  MainProjects/.../AlgebraicJacobian/Picard/JacobianDataCharts.lean
MM MainProjects/.../AlgebraicJacobian.lean
MM MainProjects/.../informal/w4-rep-critical-path.md
```

The staged blobs are byte-identical to `c70ddc580` — the commit *before* `7f6436d89`:

| path | index blob | = | HEAD blob |
|---|---|---|---|
| `AlgebraicJacobian.lean` | `ea54b50263…` | `c70ddc580` | `755881451…` |
| `informal/w4-rep-critical-path.md` | `cb13ad1c41…` | `c70ddc580` | `fce8d0b1d…` |
| `Picard/JacobianDataCharts.lean` | *absent from index* | — | present |

Any agent running a bare `git commit` publishes a commit that deletes `JacobianDataCharts.lean`, un-roots it from `AlgebraicJacobian.lean`, and strips §7 from the worksheet — in one shot. The worktree is correct; only the index is wrong. Fix: `"$HORIZON_GIT" reset -- MainProjects/Algebraic-Jacobian-Challenge-Rebuild/`. Third occurrence of this failure. Filed as **I-0366**.

Also uncommitted on disk right now (both sorry-free, both unrooted): `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0AtlasFromDivRep.lean` and `.../DivRepGlobalClassify.lean`. That is exactly the pattern I-0362 warns about, recurring inside the same run.

## The five claims

**1. "Reduces to exactly a finite Zariski atlas" — TRUE on types, MISLEADING on cost.**

The type match is genuine, not a restatement. `Pic0SigmaSheaf.lean:58-60` defines `pic0TypeFunctor` as a `noncomputable abbrev` for `(pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat` — literally the spelling `JacobianData.rep` is typed against at `JacobianData.lean:93`. `JacobianData.ofRepresentableBy` (`JacobianDataCharts.lean:71`) sets `rep := rep` with no transport. `ofCharts` (`:182`) carries only the three frozen hypotheses. Nothing smuggled. The `.olean` exists (built 07-27 00:52, source 00:48), 0 axioms, 0 `native_decide`, 0 `@[implemented_by]` tree-wide.

But **"finite" is already stale by the round's own later commit**. `9d99b0451` added `ofChartsOfCompactSpace` (`:209`), and that file's own §"What remains" (`:266-273`) says the classical atlas is *not* finitely indexed. §7.5 was not amended. The honest obligation is: an atlas with arbitrary `ι`, **plus** `CompactSpace` of the glued object — which the file itself calls "a theorem about the Jacobian, not a bookkeeping hypothesis." Filed as **I-0368** (which also notes §7.2's citation `JacobianDataCharts.lean:210` is now `:237`).

**2. `GeometricallyReduced` redundancy — VERIFIED, both halves.** `Curve/GeometricallyReduced.lean:130` and `:140` are both `instance (priority := 100)`. Independently computed chain into `Pic0SigmaSheaf`'s closure: `Pic0SigmaSheaf → PicEtCoverBridge → Pic0ZariskiSheaf → Pic0Functor → PicEtMap → PicEtMapToolkit → PicEtAffZariskiGlue → PicEtAffZariskiSep → RelPicPi → ProjectionUnits → Separatedness → UniversalSections → Curve.GeometricallyReduced`. Redundant, not a gap. The top of the chain is fine.

**3. L9 rooted — VERIFIED.** `AlgebraicJacobian.lean:420` → `Picard/DivRepGlobalLift.lean` → `:6` `Picard/DivRepKit.lean` (sole importer in the tree). Independently recomputed closure: 530 of 624 modules rooted.

**4. §7.3 vs ADDENDUM 4 — NOT the same claim, and §7.3's "over any field" is unproven.** Filed as **I-0367**.

They are different witnesses. ADDENDUM 4 §4.3 (`spec-dd-r.md:809-838`) uses the universal divisor over `T = Sym^g C`, irreducibility coming from the finite surjection `C × Sym^{g−1}C → C × Sym^g C`. §7.3 (`w4-rep-critical-path.md:226-234`) uses a *pencil*: the graph of a degree-`g` map `φ : C → P¹`, so `supp D = φ⁻¹(U)` is literally an open of `C`. That needs no `Sym^g` — genuinely cheaper, and a real contribution. But it is a new result, not corroboration.

The shrink-stability step you flagged is **fine** in both: a nonempty open of an irreducible space is irreducible hence connected, and under the graph reading "an open subscheme of the irreducible `C`" is literally correct. That is not where it breaks. It breaks on residue degrees:

> §7.3 writes the divisor `s₀ + s_∞` and computes `ℓ(K − s₀ − s_∞) ≥ g − 2`, i.e. it treats `s₀, s_∞` as **degree-1 points**. Over a non-closed field the minimal closed points `q₀ ∈ π⁻¹(p₀)`, `q₁ ∈ π⁻¹(p₁)` have residue degrees `e₀, e₁`, and an effective `E ≥ q₀ + q₁` of degree `g` exists only if `e₀ + e₁ ≤ g`. Over `𝔽₂` with `g = 2`, `e₀ = e₁ = 2`, §7.3's witness does not exist.

That is precisely the regime ADDENDUM 4 §4.4's "only if" isolates. ADDENDUM 4 §4.3 step 3 dodges it deliberately — base-change to `L`, pad by `(g−1)Q₀` — and says so at `spec-dd-r.md:826` ("No rational-point hypothesis is used anywhere"). Secondary: §7.3's `g = 2` case needs `π` chosen so `s_∞ = ι(s₀)`; ADDENDUM 4 holds for "`π` any finite dominant map" (`:812`).

Conclusion unchanged (the fixed-pair route is dead over any field — ADDENDUM 4 establishes it). But strike §7.3's "it agrees" and its "over any field", and relabel it as the cheap pencil witness with side condition `e₀ + e₁ ≤ g`.

**5. Framing on `archon-protected.yaml` — CORRECT.** `/home/axel/.../Algebraic-Jacobian-Challenge-Rebuild/archon-protected.yaml:2-4`:

```
# Declarations whose signatures must not be modified by any agent.
# The mathematician owns these; agents are read-only on the signatures and must
# discharge the `sorry`s by building infrastructure, never by weakening or restating them.
```

with `- AlgebraicGeometry.Jacobian` in the list. `Challenge.lean:96-99` binds `{k : Type u} [Field k]`; adding `[Infinite k]` is a signature modification. R1-only cannot discharge `Challenge.lean:99`. Framing holds.

## The move this round missed

**§7.5's clause (2) is not an independent roadmap leaf — it is the R1/R2 gate itself.** Filed as **I-0369**.

Traced: `ofCharts` needs `f i : yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1`. The only builder is `abelSigmaChart` (`Pic0AtlasFromDivRep.lean:192`, uncommitted), which consumes `(divFunctor C π n).RepresentableBy D`, supplied by `DivRepKit.lean:113`. But `DivisorFamilyZarFunctor.lean:41-45` defines `divFunctor` as **"the locally *certified* degree-`n` divisor families"**. So clause (2) — `IsLocallySurjective (Sigma.desc f)` — asserts that *certified* families cover, which is exactly what ADDENDUM 3 answered NO to and ADDENDUM 4 §4.3 refuted on the `g ≥ 2` stratum. §7.5 routes it to "dat-b B-6" as if it were free. Two of the three clauses sit downstream of the unresolved R1/R2 decision; only clause (3) is genuinely cheap. A session planning off §7.5 as written will underestimate by the whole descent-or-refactor campaign.

Also: `DivRepGlobalData` still has no producer, so even the certified representation is currently vacuous.

## Hygiene

- **`sorry` outside `Challenge.lean`: one** — `Picard/Pic0ThetaCocycle.lean:268`, in an orphan module whose own header says not to root it. `Challenge.lean` has 15 in code (18 raw grep lines; 16, 18, 165 are prose). Zero closed this round, as in rounds 0-4.
- **94 of 624 modules unrooted**, up from the 93/620 recorded in `AJCR.w4-rep.build-reach`. Round 5 added two more (`Pic0AtlasFromDivRep`, `DivRepGlobalClassify`). `lakefile.toml` has no `globs`, so these are never elaborated. ~8 `done` DD-R rows rest entirely on such modules — already I-0361, still open.
- **Roadmap not reconciled** (filed as **I-0370**): `AJCR.w4-rep.yaml` still says L2 "MISSING" and L9 "UNROOTED"; `dat-j` still `pending` and pre-DJ-2; `divrep.lift` still targets `DivRepGlobalData.ofAffine`, which exists nowhere; `field-size` is `done` but its title still reads "the one remaining human decision". I-0346 was answered in round 4 and never closed; I-0351–I-0357 all still open.
- **Correction to your premise:** the "circling" verdict is **round 2's**, not round 4's — `runs/0048/sessions/0006-horizon-ajcr-w4-rep-free/subagents/0004-ground/report.md:3`. Rounds 3, 4 and 5 ran no `ground` and no `work-reviewer` at all; rounds 3 and 4 produced no report (both `report.md` files contain only "You've hit your session limit"). Round 4 cost $144 with no written report. The verdict has gone three rounds untested.
- **Commits `009637d06` and `ea62cf030` are not this task** — trailers say `Archon-Task: ajc-optimize`, project `Algebraic-Jacobian-Challenge` (the sibling). Audited anyway: not status inflation (28 done + 1 pending, not the "30" in the subject; 119/119 resolvable cited modules exist and are rooted; the one sorry-carrying cited module sits under the row correctly left `pending`).

## Verdict: still circling, but for the first time productively

Round 5 is the best of the five and it is not enough. Real: `JacobianData` went from zero producers to three (`JacobianDataCharts.lean:71, :182, :209`), sorry-free, rooted, kernel-checked; L9 rooted; ADDENDUM 4's sharp iff is a genuine result. Not real: **zero of `Challenge.lean`'s 15 sorries closed, same as rounds 0-4**, and the strategic frontier (R1 vs R2) is exactly where round 4 left it. The round refactored the *statement* of the remaining obligation into a cleaner shape without moving the obligation — and §7.5 then reported that refactoring in language ("reduces to exactly", "finite") that overstates it. That is the round-2 ground reviewer's warning verbatim: circling in a way that looks like progress.

## Single highest-value next action

`"$HORIZON_GIT" reset -- MainProjects/Algebraic-Jacobian-Challenge-Rebuild/`, then commit and root `Pic0AtlasFromDivRep.lean` and `DivRepGlobalClassify.lean`. Everything the round produced is one bare `git commit` away from being deleted, and the two most valuable artifacts are invisible to the build. Second (for the R1/R2 costing workflow, not to be duplicated here): feed it I-0369 — clause (2) of the atlas *is* the gate, so R1 cannot satisfy it over an arbitrary field, which makes R2-or-descent forced rather than merely preferable.
