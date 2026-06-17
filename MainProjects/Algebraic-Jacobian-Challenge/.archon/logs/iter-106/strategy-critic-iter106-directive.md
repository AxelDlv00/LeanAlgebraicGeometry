# Strategy Critic Directive

## Slug
iter106

## Project goal

This project formalizes in Lean 4 the Jacobian of a smooth proper geometrically irreducible curve over a field, following Christian Merten's challenge file `references/challenge.lean`. The nine declarations listed in `archon-protected.yaml` (whose signatures are frozen) are the deliverables. In particular `AbelJacobi.ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`, the four protected `Jacobian` instances (`instGrpObj`, `instIsProper`, `smoothOfRelativeDimension_genus`, `instGeometricallyIrreducible`), `genus`, and `eq_of_eqOnOpen` (Rigidity). End-state: all nine compile against named Mathlib-gap sorries with no `axiom`.

## Strategy under review

```markdown
<see below>
```

## References index

```markdown
$(cat references/summary.md)
```

## Blueprint summary

| Chapter | Topic |
|---|---|
| AbelJacobi.tex | Abel–Jacobi morphism $\phi : C \to \text{Jac}(C)$; downstream of Phase C. |
| Cohomology_MayerVietoris.tex | Čech-acyclicity engine; cech_acyclicity_consumption section consumes `cechCofaceMap_pi_smul`. |
| Cohomology_SheafCompose.tex | `Sheaf` composition + sheafification lemmas (DONE). |
| Cohomology_StructureSheafAb.tex | $\mathcal{O}_X$-structure-sheaf at the Ab-flavour (DONE). |
| Cohomology_StructureSheafModuleK.tex | $\mathcal{O}_X$-structure-sheaf at the $\text{ModuleCat } k$-flavour (DONE). |
| Differentials.tex | Cotangent sheaves + Serre duality $g = \dim H^1(C, \mathcal{O}_C)$; Phase B. |
| Genus.tex | Definition of genus and equality with $H^1$ rank (DONE except instance routing). |
| Jacobian.tex | Albanese / Jacobian existence + instance routing; Phase C3 deferred via JacobianWitness pattern. |
| Modules_Monoidal.tex | Monoidal structure on $X.\text{Modules}$; Phase C0 deferred (Mathlib gap). |
| Picard_Functor.tex | Picard functor representability; gated on Phase C1 (LineBundle). |
| Picard_FunctorAb.tex | Picard functor at the Ab-flavour (DONE). |
| Picard_LineBundle.tex | LineBundle = $\text{CommRing.Pic } \Gamma(X, \top)$ approximation; Phase C1 refactor pending. |
| Rigidity.tex | `eq_of_eqOnOpen` lemma (DONE iter-002). |

## Prior critique status

You issued an iter-105 critique returning CHALLENGE on Phases A, C1, C2; REJECT on Phase C3; CHALLENGE on D/E framing. The plan agent's iter-105 response was:
- **Phase A**: STRATEGY.md updated with an iter-108 abort policy committing to refactor/route-pivot if option 3 fails (NO further wrapper engineering).
- **Phase C1**: Revised estimate 3 iters / ~100 LOC → 5–8 iters / 200–300 LOC. Promotion trigger added.
- **Phase C2**: Revised 2 iters / ~50 LOC → 4–6 iters / ~150 LOC.
- **Phase C3**: Adopted JacobianWitness exit policy. The protected signatures compile against a `Nonempty (JacobianWitness C)` witness; `nonempty_jacobianWitness` is the single named Mathlib-gap sorry at `Jacobian.lean:179`. Phase C3 NOT scheduled for closure within autonomous-loop scope.
- **Phases D/E**: Re-statused from "closed iter-073" to "BLOCKED-ON-C3-WITNESS".

**Live status entering iter-106 (Archon)**: The iter-107 (project narrative) prover lane committed to option 3 (per progress-critic primary corrective). Independent verification confirms: prover dispatched 6 distinct attempts (rw [ModuleCat.hom_zsmul], generalize hσ + zsmul rw, body-local rfl-helpers, simp [ModuleCat.hom_smul], reverse the L1114 simp, change/show with named family + explicit eqToHom proof). **All 6 attempts failed** at the SAME root cause: discrim-tree pattern unification + whnf reduction on the anonymous-closure Pi.lift codomain. The iter-108 abort policy is therefore TRIGGERED. The prover staged `h_iter104 := cechCofaceMap_summand_family_R_linear hU s₀ n hn i r' y'` as a body-local have at L1119 — load-bearing partial progress — but the trailing sorry at L1120 remains.

Your job this iter: re-verify whether the STRATEGY.md is still sound given option 3 has empirically failed and the abort policy is triggered. Phase A is now 8 PARTIAL iters deep on the same slot. Pay particular attention to:
(a) whether the proposed iter-108 acceptable shapes (refactor `cechCofaceMap_pi_smul` body / re-dispatch strategy-critic mid-iter / user escalation) are themselves credible alternatives, or sunk-cost continuation of Phase A;
(b) whether an entirely different Phase A decomposition would be cheaper (e.g. attack a different Phase A sorry like L1808 `h_loc_exact` first; or a Phase B sorry the project hasn't been blocked on; or pivot to lean-auditor-iter105 must-fix items);
(c) whether the C1 promotion trigger ("Phase A stalls 7 iters → promote C1") should now fire;
(d) goal-alignment of the JacobianWitness exit policy for Phase C3.

Reply with verdicts on every route + at least 2 named alternatives if Phase A continuation looks like sunk cost.

## STRATEGY.md verbatim

```markdown
# Strategy

## How to read this file

Forward-looking only. The mathematician should be able to see, at a glance, **what
remains** between today and the end-state and **in what order** the remaining work
must happen. History lives in `task_done.md`; per-iteration recipes live in
`PROGRESS.md`. This file is the arc.

## Estimations (auto-maintained)

| Phase | Iterations remaining | LOC remaining | Status |
|---|---:|---:|---|
| A — Čech acyclicity (`BasicOpenCech.lean`) | ~4–7 | ~80 | **Iter-107 plan: route pivot to option 3 (discard wrapper engine for L1145 closure)** per progress-critic STUCK verdict (iter-099/100/101/103/105/106 = 6 PARTIAL on this slot with recurring blockers "anonymous-closure Pi.lift codomain", "discrim-tree pattern-unification", "eqToHom-vs-Pi.π transport"). Iter-106 Route 1 lemma `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'` backed out (refactor iter107-cleanup). Wrapper helpers `cechCofaceMap_summand_family'` + `_R_linear` (iter-105, fully proved) **kept as inert infrastructure** but NOT load-bearing for L1145 closure. Iter-107 prover applies iter-104's `cechCofaceMap_summand_family_R_linear` directly at the per-summand discharge in `cechCofaceMap_pi_smul`'s body (replacing the iter-105 wrapper invocation in the partial-proof scaffold at L1106–L1144). **Iter-108 commitment**: if iter-107 option 3 also stalls, escalate to refactor of `cechCofaceMap_pi_smul`'s body OR re-dispatch `strategy-critic` mid-iter on a revised Phase A strategy; do NOT continue wrapper engineering. |
| B — Cotangent sheaves (`Differentials.lean`) | ~8–12 | ~250 | 5 sorries; `h_exact` deferred parallel to `instIsMonoidal_W`. Both Mathlib routes (stalkwise + section-wise) absent. Iter107-cleanup removed 238-line dead-code block (`ITER-076 disabled chain`); compile-clean. |
| C0 — Monoidal `X.Modules` | — | 0 | `instIsMonoidal_W` deferred (Mathlib gap `stalk_tensorObj` for varying-ring R₀). Not gating other phases. |
| C1 — Refined `LineBundle` | ~5–8 | ~200–300 | Strategy-critic-iter105 revised: estimate up from 3 iters / ~100 LOC (the comm-group structure on `Invertible (X.Modules)` may itself need new lemmas about tensor inverses being unique up to iso). lean-auditor-iter104 + blueprint-reviewer-iter105 flagged the CRITICAL `LineBundle X := CommRing.Pic Γ(X, ⊤)` excuse-comment (admitted-wrong on non-affine schemes by its own docstring; trivial for ℙⁿ vs true Pic ℤ). Iter105 blueprint-writer added Lean-state status note to `Picard_LineBundle.tex`. **Containment guard**: `PicardFunctor.representable` (`Picard/Functor.lean` L190) refuses closure on top of the approximation; no `theorem`/`lemma` is proved against the wrong def. **Promotion trigger for C1 ahead of A**: if Phase A stalls a 7th iter (i.e. iter-107 option 3 ALSO fails AND no refactor breakthrough), promote C1 ahead of further A work — Phase A residuals would be queued and C1 refactor begins. |
| C2 — `PicardFunctor` re-derivation | ~4–6 | ~150 | Strategy-critic-iter105 revised: estimate up from 2 iters / ~50 LOC. Full re-derivation including étale sheafification and abelian-group structure on top of new `LineBundle`. |
| C3 — Representability / `JacobianWitness` | **see "Phase C3 exit policy" below** | — | Strategy-critic-iter105 REJECT on original estimate (10–15 iters / ~1500 LOC wildly under-counted; realistic 50–150 iters / 5,000–15,000 LOC for either FGA-Hilbert or `Sym^g/S_g`). **Exit policy adopted iter-107**: defer C3 indefinitely via `JacobianWitness`-witness pattern (consistent with existing deferrals for `h_exact` and `instIsMonoidal_W`). The protected signatures compile against the `Nonempty (JacobianWitness C)` witness; the `nonempty_jacobianWitness` sorry at `Jacobian.lean:179` is the single named gap on a precise Mathlib gap (Hilbert/Quot schemes; finite-group quotients of schemes — both confirmed absent from Mathlib b80f227). **NOT scheduled for closure within this project's autonomous-loop scope.** Strategy-critic-suggested alternative "divisor-class-image Pic⁰" (avoids Hilbert + Sym^g via scheme-theoretic image of `C^g → Pic^g`) is documented as a future-work option but not selected — it still requires scheme-theoretic image API + Riemann–Roch effective theory that are themselves Mathlib gaps. |
| D — `genus`/`Jacobian`/instances | 0 (closed iter-073) | 0 | File-level closure (no inline `sorry`). **Content-level: BLOCKED-ON-C3-WITNESS** — all instance bodies route through `nonempty_jacobianWitness`. Strategy-critic-iter105 CHALLENGE accepted: the framing here reflects that file-level signatures are honored against the deferred witness, NOT that mathematical content is delivered. |
| E — Abel–Jacobi | 0 (closed iter-073) | 0 | Identical to D. **Content-level: BLOCKED-ON-C3-WITNESS.** |

**Aggregate (revised iter-107)**: ~21–33 prover iterations and ~480–630 LOC remain for **what the autonomous loop will deliver** (Phases A, B, C1, C2). Phase C3 is deferred via `JacobianWitness` pattern; the protected `Jacobian`/`ofCurve` signatures compile against a sorry-routed witness, mirroring `h_exact` and `instIsMonoidal_W`. The final project terminates with **exactly 4 named Mathlib-gap sorries** in scope: `instIsMonoidal_W` (varying-ring stalk), `h_exact` (sheaf-of-modules exactness criterion), `nonempty_jacobianWitness` (Hilbert/Quot schemes + finite-group quotients), and `PicardFunctor.representable` (gated on `JacobianWitness`). Plus `BasicOpenCech.lean`'s `h_loc_exact` (`IsLocalizedModule.Away f.1` on finite products, ~80 LOC Mathlib gap-fill — TRACTABLE within scope, will be closed during Phase A). All other sorries close within the autonomous loop.

## Phase C3 exit policy (adopted iter-107 in response to strategy-critic REJECT)

The strategy-critic-iter105 audit returned REJECT on Phase C3 with the argument that both proposed routes (FGA-via-Hilbert; `Sym^g C / S_g`) require constructing Mathlib infrastructure (Hilbert scheme; finite-group scheme quotient) that is a Hartshorne-chapter-sized undertaking (~5,000–10,000 LOC each), wildly exceeding the project's stated estimate.

**Adopted exit policy**: defer Phase C3 indefinitely via the `JacobianWitness`-witness pattern. The protected `Jacobian C`, `ofCurve P`, and downstream instances (`GrpObj`, `IsProper`, `GeometricallyIrreducible`, `SmoothOfRelativeDimension`) carry sorry-routed bodies that reduce to `Nonempty (JacobianWitness C)`, where `JacobianWitness C : Type` is a structure with a `sorry`-bodied existence at `Jacobian.lean:179`. This is **mathematically honest**: the project delivers a *framework* for the Jacobian (genus, Picard functor, all instance plumbing) that bottoms out in a single named Mathlib gap.

The strategy-critic's "divisor-class-image Pic⁰" alternative (avoiding both Hilbert and Sym^g via scheme-theoretic image of `C^g → Pic^g` + Riemann–Roch effective theory) is documented as a future-work option for whoever picks up the project after Mathlib's algebraic-geometry foundations are deeper. It is NOT selected as a within-scope route because the prerequisite infrastructure (scheme-theoretic image API in the relevant generality; Riemann–Roch effective theory at the curve level; the birational-image-is-group-scheme step) is itself missing from Mathlib b80f227.

**Status of Phases D and E**: re-classified from "closed iter-073" to "BLOCKED-ON-C3-WITNESS". The protected declarations compile with sorry-routed witnesses (file-level closure: no inline `sorry` in `Genus.lean`, `Jacobian.lean` (except the witness sorry), `AbelJacobi.lean`); the *mathematical content* of D and E depends on closure of `nonempty_jacobianWitness` (C3). This framing is the **honest accounting** of what the project delivers: signatures compile + sorries are named + the gap-fill is on the Mathlib side.

## End-state

`Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean` compile with **only the named Mathlib-gap sorries listed above** and **no new `axiom`**. The nine declarations in `archon-protected.yaml` carry the intended mathematical content **up to the JacobianWitness gap**, with all other infrastructure (Čech cohomology, cotangent sheaves, sheafified Picard functor) delivered.

## Honest assessment of Phase A (iter-107 status)

Lane 1 target `cechCofaceMap_pi_smul` trailing sorry at L1145 (was L1147/L1179 across iter rewrites) has been the active prover lane since iter-099. Progress-critic-iter105 STUCK verdict: 6 PARTIAL iters on this slot with recurring structural blockers ("anonymous-closure Pi.lift codomain", "discrim-tree pattern-unification", "eqToHom-vs-Pi.π transport identification"). Iter-105 added wrapper helpers + structured partial proof at L1106–L1144; iter-106 added Route 1 morphism-equality lemma signature with sorry body that 7 closure attempts could not discharge.

**Iter-107 commits to option 3** (per progress-critic primary corrective + strategy-critic-iter105 alternative #3): discard the wrapper-engine approach. The iter-105 wrapper helpers (`cechCofaceMap_summand_family'`, `cechCofaceMap_summand_family'_R_linear`) remain as inert infrastructure (fully proved, ~120 LOC); the iter-104 named-family R-linearity `cechCofaceMap_summand_family_R_linear` (also fully proved) is applied DIRECTLY at the per-summand discharge in `cechCofaceMap_pi_smul`'s body. The Fin-index-type mismatch between the call-site Pi.lift (`Fin ((prev n) + 2)`) and the wrapper target (`Fin (n+1)`) is bypassed: option 3 stays at the call-site index type and uses iter-104's R-linearity (which is at THAT type) without going through the wrapper's eqToHom transport.

**Iter-108 commitment** (in response to strategy-critic CHALLENGE on Phase A): if iter-107 option 3 also fails to close L1145, the loop escalates to deeper refactor or route-pivot — do NOT continue wrapper engineering or scalar-extraction tactic budgets. Acceptable iter-108 shapes: (a) refactor `cechCofaceMap_pi_smul`'s body to use a different decomposition (e.g. `cechCofaceMap_summand_family` extracted at the outer sum index rather than the inner Pi.lift), (b) re-dispatch `strategy-critic` mid-iter to validate a Phase A route replacement, (c) `user-escalation` if neither (a) nor (b) converges. Wrapper engineering as such is committed to NOT be repeated.

## Mathlib gaps in scope

| Gap | Phase | Plan |
|---|---|---|
| Stalkwise criterion for `SheafOfModules` exactness | B | Both routes confirmed Mathlib-gap blocked (iter-086 audit). `h_exact` deferred parallel to `instIsMonoidal_W`. |
| `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗ N.stalk x` (varying-ring `R₀`) | C0 | Defer indefinitely; downstream not gated. |
| Sheaf cohomology `Hⁱ(X, F)` for quasi-coherent sheaves | A | Project-local `HModule`/`HModule'` via `Abelian.Ext` (built iter-003–008). |
| `IsLocalizedModule.Away f.1` on finite products | A | Needed for `h_loc_exact` (BasicOpenCech.lean L1808). Tractable iter-108+; ~80 LOC project-local gap-fill. |
| Hilbert / Quot schemes | C3-DEFERRED | Phase C3 deferred via JacobianWitness exit policy. |
| Finite-group quotients of schemes | C3-DEFERRED | Same. |
| Riemann–Roch effective theory + scheme-theoretic image (for divisor-class-image alternative) | C3-DEFERRED | Mathlib gap; the strategy-critic-suggested "divisor-class-image Pic⁰" route is documented but not selected. |

## Path from today to the end-state

### Iter-107 (this iter's plan)

**Single substantive prover lane**: close `cechCofaceMap_pi_smul` trailing sorry at L1145 of `BasicOpenCech.lean` via **option 3** (direct application of iter-104's `cechCofaceMap_summand_family_R_linear` at the per-summand discharge, bypassing the iter-105 wrapper engine).

Refactor + 3 blueprint-writers landed pre-prover-dispatch:
- **Refactor iter107-cleanup**: backed out iter-106 Route 1 lemma (-1 sorry); rewrote 4 stale "body sorry" docstrings to describe the iter-097/099/103/104 closures; removed iter-107 excuse-comment block inside `cechCofaceMap_pi_smul`; trimmed iter-102 NOTE paragraph; removed Differentials 238-line dead-code block. Net BasicOpenCech 7 → 6 sorries; total 15 → 14.
- **Blueprint-writer mv-fix**: fixed broken `\uses{def:Scheme_HModule_eq_HModule_prime_linearEquiv}` at `Cohomology_MayerVietoris.tex:779`.
- **Blueprint-writer ssmk-fix**: fixed broken `\uses{def:Scheme_HModule'}` at `Cohomology_StructureSheafModuleK.tex:629`.
- **Blueprint-writer linebundle-status**: added Lean-state status note + `% NOTE:` markers to `Picard_LineBundle.tex` documenting the LineBundle approximation.

**Target net**: BasicOpenCech 6 → 5 sorries (close L1145). FILE MUST COMPILE.

### Iter-108+

Branches on iter-107 outcome:
- **If iter-107 closes L1145**: schedule next prover lane on `g_R.map_smul'` (L1779, gated on L1145 closure + `Eq.mpr` cast handling) + dispatch the queued blueprint-writer for `Cohomology_MayerVietoris.tex` § Čech acyclicity (single consolidated paragraph documenting the iter-104/105/106 named-family engine).
- **If iter-107 stalls on L1145** (option 3 also fails): per the iter-108 commitment above, escalate to refactor of `cechCofaceMap_pi_smul`'s body OR re-dispatch `strategy-critic`. Do NOT continue wrapper engineering or scalar-extraction tactic budgets.

### Mid-term — Phase B (~iter-110+)

Address `Differentials.lean` non-`h_exact` sorries (L113 `relativeDifferentialsPresheaf_isSheaf`, L711 `smooth_iff_locally_free_omega`, L727 `cotangent_at_section`, L871 `serre_duality_genus`). `h_exact` (L517) stays deferred parallel to `instIsMonoidal_W`.

### Mid-term — Phase C1 (`LineBundle` refactor)

Refactor subagent: rewrite `Picard/LineBundle.lean` body from `CommRing.Pic Γ(X, ⊤)` to `MonoidalCategory.Invertible (X.Modules)`. Protected signature stays. Re-establish `instCommGroupLineBundle` and `Pic.pullback`. Estimate 5–8 iters / 200–300 LOC (strategy-critic-iter105 revised). **Promotion trigger**: if iter-107 + iter-108 both stall on Phase A residuals, promote C1 ahead of further A work.

### Mid-term — Phase C2 (`PicardFunctor` re-derivation)

Re-derive `PicardFunctor`'s `quotMap`/`fiberMap`/etale-sheafification against the new `LineBundle`. Estimate 4–6 iters / ~150 LOC (strategy-critic-iter105 revised). Sequenced after C1.

### Phase C3 — DEFERRED via `JacobianWitness` exit policy

See "Phase C3 exit policy" section above. The protected `Jacobian`/`ofCurve` carry sorry-routed bodies; `nonempty_jacobianWitness` is the named Mathlib-gap sorry at `Jacobian.lean:179`.

## Soundness rule

**No helper lemma with a universally-false signature may be introduced**, even with
a `sorry` body. Such a helper is logically an axiom; combined with `exact ... _`
applications, it bypasses any subsequent goal.

When the genuine statement is impossible to prove because of a Mathlib gap, the
project's choice is between:
(a) Leave the inline `sorry` in place at the use site (preferred — surfaces honest
status).
(b) Define an iff-form helper as a `theorem ... : iff_statement := sorry` if the
statement is mathematically TRUE; the application then exposes the unprovable side
as a fresh, named goal rather than displacing it silently. Only do this when downstream
consumers can usefully assume the iff in `simp`/`rw`/`exact` chains.

Never replace an inline `sorry` with a `sorry`-bodied helper that strengthens the
claim or with one whose signature is mathematically wrong.

The **Phase C3 exit policy** above is the soundness-rule-compliant treatment of an
unbounded Mathlib gap: keep the inline `sorry` at the witness use-site
(`nonempty_jacobianWitness`); ship the downstream signatures against the `Nonempty`
witness; surface honest status to the end-user reader.
```
