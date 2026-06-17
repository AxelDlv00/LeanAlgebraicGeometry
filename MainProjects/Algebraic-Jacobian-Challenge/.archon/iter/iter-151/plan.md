# Iter-151 plan-agent run

## Headline outcome

Iter-151 is a **USER-DIRECTED references / blueprint / strategy iter** with a
single bounded prover lane attached. The user hint replaced the entire
references overhaul + blueprint cross-referencing + a Route A re-scope
assessment. All of it executed; on top, the iter-150 KDM transfer-step
close-out runs as the progress-critic's CHURNING convergence test (gate-cleared
this phase by a writer round).

7 subagents dispatched, all returned + absorbed (3 mandatory critics + 1
retriever + 3 writers).

## Wave 1 (parallel) — retriever + 2 critics

| Subagent | Verdict | Absorption |
|---|---|---|
| `reference-retriever-stacks-fga-iter151` | **COMPLETE** — 8 genuine sources retrieved + verified (6 Stacks chapter `.tex`, Kleiman PDF+LaTeX, Nitsure PDF). All directive tag numbers correct this round. | `summary.md` rebuilt; Kleiman read first-hand for the re-scope; bundled `.tex` fed to the 3 writers. |
| `blueprint-reviewer-iter151` | **HARD GATE fires on BOTH active-lane chapters**: `ChartAlgebraS3.tex` `correct: partial` (3 stale tags); `RigidityKbar.tex` KDM block `complete: partial` (live route (C) not first-class prose). | Both remediated THIS plan phase by the writers (Wave 2). KDM lane kept live as a documented judgment call (see below). |
| `progress-critic-iter151` | **CHURNING on Route C** (5 consecutive PARTIAL, NET sorry 5→9). Corrective: staged route-pivot — run the bounded KDM close-out as the convergence test + commit a no-decomposition bright-line + escalate the genuine Mathlib gap. | Bright-line written into STRATEGY.md (standing); single KDM lane dispatched as the convergence test; TO_USER decision re-posed. NOT rebutted — adopted in full. |

## Route A re-scope assessment (user hint — read Kleiman first-hand)

Read `references/kleiman-picard.pdf` / `-src/.tex` §1 (intro Jacobian
discussion), §4 (`th:main` existence, L2155), §5 (`lem:agps` L2851, `prp:pic0`,
`prp:P0` L3661, `cor:sm` L3421, `cor:ch0`, `ex:jac` L3911, `rmk:Jac` L3990,
`rmk:Ablsch`), §6 (`rmk:curves` L4682).

**Finding.** The curve-Jacobian chain is Nitsure Quot/Hilbert (A1) →
`th:main` (§4) → `prp:P0`/`lem:agps` (§5, A2) → `ex:jac`. Kleiman states §5 is
"formal, from general principles … without the finiteness theorems" (sc:Pic0
preamble), so A2/A3 genuinely shrink. BUT `ex:jac` routes existence through
`prp:P0` → `th:main` → the full Quot/Hilbert engine, which is **irreducible
along Kleiman's route** — even "just the curve Jacobian" needs `th:main`. So
the user's "far less work" hypothesis is **PARTIALLY supported**: the reduction
is the structural tail (A2 ~1320→~800, A3 ~975→~500), not the existence engine
(A1 ~3775 unchanged). Midpoint ~6070 → **~5100 LOC**. A dramatic reduction
would need a Symⁿ/Abel–Jacobi (Weil) construction bypassing Pic representability
= Route B, already rejected. STRATEGY.md Route A section + phases table updated;
priority unchanged (off-critical-path). Strategy-critic independently judged
this re-scope SOUND and "notably honest" (A1 figure is a floor, not a ceiling).

## Wave 2 (parallel) — strategy-critic + 3 writers

| Subagent | Verdict / Result | Absorption |
|---|---|---|
| `strategy-critic-iter151` | **CHALLENGE** — (1) spine-framing: the "vacuity branch" wording conflates pointed-vs-unpointed with genus-0-vs-positive; (2) format NON-COMPLIANT (iter-stamp drift + over budget); phantom `RingHom.iterateFrobenius_comm`. Route A re-scope SOUND. | All absorbed in STRATEGY.md: pointed-vs-unpointed spine rewritten in Goal + Routes (resolved against `challenge.lean.ref` + `Jacobian.lean`'s `JacobianWitness`); iter-stamps de-stamped; phantom relabelled project-to-build; trimmed 287→252 lines. |
| `blueprint-writer-chartalgebras3-iter151` | COMPLETE | 3 tags fixed; dangling pointers retargeted; 4 verbatim (S3.*) citation blocks. → chapter now `correct: true`. |
| `blueprint-writer-rigiditykbar-iter151` | COMPLETE | **(BR.5′) route-(C) first-class prose landed** (gate-clears KDM lane); all dangling pointers retargeted; 6 verbatim citation blocks; Mumford honestly flagged not-retrieved; Tag-030K accuracy fix. |
| `blueprint-writer-jacobian-iter151` | COMPLETE | 6 verbatim Kleiman `% SOURCE QUOTE:` on Route-A declarations + Nitsure pointer. No fabrication. |

### Spine-framing resolution (strategy-critic CHALLENGE #1 + #2)

Resolved by reading the authoritative `references/challenge.lean.ref` and the
project's `Jacobian.lean` `JacobianWitness` structure:
- `JacobianWitness C` bundles a REAL object `J` (data, constructed
  unconditionally) + `isAlbaneseFor : ∀ P, IsAlbanese … J`.
- The object obligation is UNCONDITIONAL: genus-0 `J = Spec k` (trivial dim-0,
  no Picard scheme); positive-genus `J = Pic⁰` via Route A (needed even when
  `C(k)=∅`, since `J` must be a dim-`g` abelian variety regardless).
- Vacuity applies ONLY to the `∀P` field for unpointed `C`. The genus-0
  critical path therefore does NOT "close via vacuity": its non-vacuous content
  is the pointed-ℙ¹ rigidity (a `C→A` map killing `P` is constant ⟹ factors
  through `Spec k`) — which IS the Route C chart-algebra effort.
- The bad "genus-0 closes via the vacuity branch" parenthetical (which I
  introduced earlier this iter) is removed; Goal + Routes now carry the
  pointed-vs-unpointed spine explicitly. Both CHALLENGE arms resolve to the
  same correction; no rebuttal needed.

## KDM-lane judgment call (HARD GATE)

The blueprint-reviewer flagged the KDM block `complete: partial` (route (C) not
first-class) but explicitly permitted keeping the lane live since the Lean
carries thorough inline (C.a)–(C.e) docs and the prover reads the Lean. I went
further: dispatched `blueprint-writer-rigiditykbar-iter151` THIS plan phase to
land (BR.5′) route-(C) first-class prose. The writer returned COMPLETE, so by
the time the prover phase runs the blueprint describes the live route — the
gate's intent is satisfied. iter-152's mandatory reviewer confirms
`complete: true`. The progress-critic independently endorsed running this exact
bounded close-out as the convergence test (not churn).

## Decisions committed
- One prover lane: ChartAlgebra.lean KDM (C.d) transfer step (S5.a explicit /
  S5.b `subsingleton_h1Cotangent`). Guaranteed strict NET reduction 9→8 if it
  closes.
- Bright-line (standing): no further sorry-inflating decomposition on Route C;
  (C.d) failure ⇒ STUCK ⇒ pivot/escalate next iter.
- Route A LOC ~5100 (re-scope), off-critical-path priority unchanged.

## TO_USER surface (for review-agent → TO_USER.md)
Two coupled, still-unanswered decisions on the genuine Route-C Mathlib gaps:
1. **`[IsAlgClosed kbar]` on `rigidity_over_kbar`?** YES → closes
   `constants_integral_over_base_field` in ~15 LOC
   (`IsAlgClosed.algebraMap_bijective_of_isIntegral`) and descopes (S3.pi.*),
   but pushes `\bar k`-base-change + fpqc-descent into `genusZeroWitness`
   (reverses iter-127 over-k). NO → over-k kept; (S3.pi.1) stays a ~150–250 LOC
   blocker.
2. **Flat-base-change-of-Γ (S3.pi.1), genuinely absent from Mathlib b80f227:**
   build in-tree (~150–250 LOC) / axiomatize / re-route?

## Fallback if no user response
Default to **NO** on (1) (keep the iter-127 over-k commitment) and **build
in-tree** on (2). Next iter, if the KDM (C.d) close-out succeeded, proceed to
the over-k path for substep-3: attempt (S3.pi.2) (the tractable ~50–100 LOC
half) before (S3.pi.1), per the iter-150 review's STUCK-avoidance note. If the
KDM (C.d) close-out STUCK, the bright-line forces a pivot/escalation iter
instead of more decomposition.

## Subagent skips
(None — all 3 highly-recommended plan-phase critics dispatched. The 3 writers +
retriever were the user-directed work.)
