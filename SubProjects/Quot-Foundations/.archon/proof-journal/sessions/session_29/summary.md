# Session 29 — Review of iter-029 (Quot-Foundations)

## Metadata
- **Iteration / session**: iter-029 / session_29
- **Prover model**: claude-opus-4-8
- **Active sorry count**: FBC 4 → 4; QUOT 4 → 4 (protected stubs). **Net 0.**
- **New axiom-clean declarations**: 1 (`exists_finite_basicOpen_cover_le_quasicoherentData`, QUOT).
- **Lanes dispatched**: 3 (FBC `prove`, QUOT `mathlib-build`, GR `mathlib-build`).
  **GR landed nothing** (no edits, no task_result; GrassmannianCells.lean still 0 sorry, no new decls).
- **Build**: GREEN. `lean_verify` on the new QUOT decl = `{propext, Classical.choice, Quot.sound}`.
- **blueprint-doctor**: 0 findings. **sync_leanok**: ran on current tree (iter 29, sha 989fb48; +9 `\leanok`,
  0 removed; chapters = Picard_GrassmannianCells, Picard_QuotScheme).

This was a **low-yield diagnostic + cleanup iter**: 0 sorries closed, 1 helper added. Its real value is
(1) a *conclusive negative result* on FBC's `_legs` crux that rules out the entire keyed-rewriting tactic
family, and (2) clearing the two iter-028 lean-auditor must-fix docstrings + de-privatizing the 3 atoms.

---

## Target 1 — `base_change_mate_fstar_reindex_legs` (FBC @1446) — BLOCKED (definitive diagnosis)

The iter-029 plan dispatched this on the mathlib-analogist's term-mode recipe (port the GR
`congrArg`/`.trans`/`exact` mechanism, abandon `hpfc`). The prover instead produced a **definitive negative
result** establishing that NO keyed-rewriting route works at all:

- **Attempt 1** `rw [hpfc]` / `simp only [hpfc]` → "did not find pattern / no progress" (as 4 prior iters).
- **Attempt 2 (KEY NEW FINDING)** `have e2 : <factor-2 literal copied verbatim from the printed goal> = 𝟙 _ := rfl`
  **typechecks** (so the collapse IS defeq) — but the follow-up `rw [e2]` **STILL** reports "did not find
  pattern". A `rfl`-true fact whose LHS is the goal's own pretty-printed factor cannot be located by `rw`'s
  `kabstract`: the goal's factor carries a `Scheme.Modules` category/comp **instance** that is
  defeq-but-not-reducibly-equal to a fresh elaboration. `conv in`/`set` share `kabstract` → same failure.
- **Attempt 3** `dsimp only [Functor.comp_map]` → no progress; `rw [Category.comp_id]` → cannot even find
  `?f ≫ 𝟙` (every `≫` in the goal carries the diamond instance).

**Defeq map established** (each via a `have … := rfl` that typechecks):
| factor | term | defeq 𝟙? |
|---|---|---|
| factor 2 | `(pushforwardComp g' (Spec φ)).hom.app _` | YES (rfl) |
| factor 2 under Γ | `Γ.map ((pushforwardComp g' (Spec φ)).hom.app _)` | YES (rfl) |
| G3 (inner) | `(pushforwardComp e.hom (Spec inclA)).hom.app _` | YES (rfl) |
| G4 | `(pullbackComp e.hom (Spec inclA)).hom.app (tilde M)` | NO (genuine iso) |
| G1, G2 | `(g')`-unit, `(Spec inclA)_*(η^e)` | NO (genuine isos) |

**Conclusion**: the ONLY mechanism that bridges the diamond is **whole-term defeq** (`have … := rfl`
typechecks ⇒ `change`/`exact`/`convert` can bridge). The proof must be a **single hand-built ~100–150 LOC
proof term closed by one `exact …`/`convert … using n`**, splicing the genuine-content lemmas on
*separately-elaborated clean terms* (single instance in play ⇒ no diamond), chained with `congrArg`/`.trans`,
touching the goal only at the final `exact`. All genuine-content helpers already exist + proven in-file:
`_legs_gammaDistribute` (@1304), `inner_eCancel_eUnit`/`_pushforwardComp`/`_pullbackComp` (@1523/1535/1552),
`unit_value` (@987). The remaining work is the assembly proof term alone.

**Riders done (all compile):** removed dead `have hpfc`; de-privatized the 3 atoms
`gammaMap_pushforwardComp_hom_eq_id`/`_inv_eq_id`/`gammaMap_pushforwardCongr_hom` (`private lemma` →
`lemma`, so blueprint `\lean{}` pins resolve); fixed the 2 iter-028 must-fix false "sorry-free" docstrings
(@1838, @1911) to "body has no inline `sorry` but is transitively `sorry`-backed through
`base_change_mate_gstar_transpose`".

## Target 2 — `base_change_mate_gstar_transpose` (FBC @1818) — BLOCKED (gated)
Untouched. Consumes `base_change_mate_inner_value_eq` (= concrete form of `_legs`), still sorry-backed; own
residual `ε_g` rewrite hits the same diamond. Cascades once `_legs` lands.

## Target 3 — `exists_finite_basicOpen_cover_le_quasicoherentData` (QUOT @730) — SOLVED (axiom-clean)
The topological finite-cover front of `lem:exists_isIso_fromTildeΓ_basicOpen_cover` (drops the `IsIso`
conclusion). Proof: `G := {r | ∃ i, basicOpen r ≤ q.X i}`; `Ideal.span G = ⊤` via
`← PrimeSpectrum.iSup_basicOpen_eq_top_iff'` + `eq_top_iff` + `Opens.mem_iSup`; each point covered by
`q.coversTop ⊤ x trivial` → `Sieve.mem_ofObjects_iff` → `leOfHom` → `Opens.isBasis_iff_nbhd.mp
PrimeSpectrum.isBasis_basic_opens`; `Ideal.span_eq_top_iff_finite` extracts the finite `t`. The prover
**dropped** a bundled `…_of_isQuasicoherent` corollary: the existential's `QuasicoherentData` index universe
is independent of the `[IsQuasicoherent]` instance's auto-bound universe, and the explicit universe naming
(`universe w in theorem …`) failed to parse — downstream callers do the 2-line `obtain` directly.

## Target 4 — `isIso_fromTildeΓ_of_isQuasicoherent` (gap1, QUOT) — BLOCKED (multi-iter sub-build)
The engine is fully in-file (the iff + 3-field reduction). Only the **local-presentation → global** step is
missing, and it needs a **per-element presentation transport**: turn `q.presentation i :
(M.over (q.X i)).Presentation` into a presentation of `M|_{D(r)} : (Spec R_r).Modules`. This requires a
scheme-level modules restriction-to-basic-open functor + `over`↔scheme-pullback identification + presentation
transport — **none exist in Mathlib** (`AlgebraicGeometry/Modules/` = only `Presheaf/Sheaf/Tilde`). Practical
aggravation: even *stating* `q.presentation i` triggers a `synthInstance` heartbeat **timeout** (20000) on
the slice `(sheafToPresheaf (J.over (q.X i)) _).IsRightAdjoint` (probed live). Three independent routes
(cover-transport, stalk, section-MV) all funnel through this same transport. Named next ingredient:
`restrictModulesToBasicOpen : (Spec R).Modules ⥤ (Spec R_r).Modules` + Presentation-transport.

## GR lane — no output
Dispatched as `mathlib-build` (cocycle ring identity + glued scheme) but produced no edits and no
task_result; `GrassmannianCells.lean` is unchanged (0 sorry, no new decls; dag `unmatched` shows no GR node).

---

## Review subagents
- **lean-auditor `iter029`** (FBC+QUOT) — **CLEAN**, 0 critical/major, 1 minor (editorial "definitive"
  overstatement in the FBC diagnosis box). Confirmed: docstring fixes honest (not laundering), new QUOT
  helper genuine. → `.archon/task_results/lean-auditor-iter029.md`
- **lean-vs-blueprint-checker `fbc`** — **PASS**, 0 must-fix; 1 major = stale `% NOTE:` (chapter
  lines 1541–1546) falsely claiming the 3 atoms are `private` with mangled names. **FIXED by me this iter**
  (removed the NOTE). 45/45 pins resolve; coverage complete; all 4 known-open sorrys have adequate blueprint.
  → `.archon/task_results/lean-vs-blueprint-checker-fbc.md`
- **lean-vs-blueprint-checker `quot`** — faithful, 0 must-fix; 2 major + 2 minor (see recommendations).
  gap1 honestly represented with `% NOTE:`. → `.archon/task_results/lean-vs-blueprint-checker-quot.md`

## Blueprint markers updated (manual)
- `Cohomology_FlatBaseChange.tex`, `lem:gammaMap_pushforwardComp_hom_eq_id`: removed stale `% NOTE:`
  (lines 1541–1546) — the 3 atoms are now public (de-privatized this iter), pins resolve, names not mangled.
- `Picard_QuotScheme.tex`, `lem:exists_isIso_fromTildeΓ_basicOpen_cover`: added `% NOTE: (iter-029)`
  recording that the topological precursor (`exists_finite_basicOpen_cover_le_quasicoherentData`) landed
  axiom-clean this iter and owes its own sub-lemma block (coverage debt); the full IsIso-carrying statement
  awaits the presentation transport.

## Key findings / patterns
- **FBC `X.Modules` instance diamond is total against keyed rewriting.** `rw`/`simp`/`erw`/`conv`/`set`/
  `dsimp` ALL fail — even on `rfl`-true facts and even `Category.comp_id` — because every `≫`/`Functor.map`
  in the goal carries a category/comp instance that is defeq-but-not-reducibly-equal to a fresh elaboration.
  Bridging requires whole-term defeq via `exact`/`convert`/`change` only. (Memory: `fbc-ecancel-collapse-diamond`,
  now sharpened.)
- **QUOT QuasicoherentData slice transport wall** confirmed: stating `q.presentation i` times out
  synthInstance; no Mathlib `over`↔pullback / restriction-to-`Spec R_g` transport. (Memory:
  `quot-quasicoherentdata-slice-transport-wall`.)
- **Universe friction**: `[IsQuasicoherent.{w}]`'s auto-bound universe does not unify with a
  `QuasicoherentData.{?}` existential index without explicit naming; `universe w in theorem` is a parse
  error mid-namespace. Prefer the 2-line `obtain ⟨q⟩ := h.nonempty_quasicoherentData` at call sites.

See `recommendations.md` for next-iter actions.
