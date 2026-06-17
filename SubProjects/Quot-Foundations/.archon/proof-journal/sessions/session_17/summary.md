# Session 17 — Review (iter-017)

## Metadata

- **Iteration / session:** iter-017 / session_17
- **Build:** GREEN — `lake build` of all 3 modified modules → EXIT 0 (re-verified independently this
  review; only expected `sorry` warnings). `blueprint-doctor`: no structural findings. `gaps`: 0 ∞-holes.
- **Active sorry per file (term-level):**
  - FlatBaseChange.lean: **4 → 4** (Seam-2 content sorry MOVED + shrank — see below)
  - FlatteningStratification.lean: **4 → 3** (**−1**, L5 closed)
  - QuotScheme.lean: **4 → 4** (the 4 pre-existing protected stubs; +13 new axiom-clean decls, additive)
  - GrassmannianCells.lean / RegroupHelper.lean: 0 / 0 (DONE)
- **Net this iter: −1 active sorry; +1 axiom-clean target (GF L5); +18 new axiom-clean declarations**
  (4 FBC Γ-collapse/codomain-read lemmas + 13 QUOT ambient-calculus + 1 GF signature simplification),
  all re-verified `{propext, Classical.choice, Quot.sound}` via the prover's `lean_verify` and my build.
- **3-lane prover dispatch (FBC fine-grained, GF prove, QUOT mathlib-build); all 3 delivered real
  axiom-clean content.** Two multi-iter walls broke: the FBC Seam-2 "motive is not type correct" wall
  (iters 014–016) and the GF L5 OreLocalization instance-presentation diamond (iters 015–016).

## Targets attempted

### FBC — Seam 2 (`base_change_mate_fstar_reindex`) — STRUCTURAL WALL DISSOLVED, content sorry isolated

The progress-critic flagged FBC **CHURNING** (Seam-2 sorry static iters 014–016; two closed helpers
added without dissolving the wall). The fine-grained corrective (subst-able legs, NOT another opaque
helper) **worked**:

- **Dissolved the "motive is not type correct" wall.** The two pullback legs sat in dependent
  positions (adjunction index, the `(IsPullback…).w` proof inside `pushforwardCongr`, the
  `gammaPushforwardIso` arg, and — load-bearing — the *type* of `base_change_mate_codomain_read`), so
  `rw [hfst]`/`rw [hsnd]` failed for two prover iters. Fix: restate with the legs as **free
  variables** `g' f'` (`base_change_mate_codomain_read_legs`, `base_change_mate_fstar_reindex_legs`),
  so `subst hfst; subst hsnd` acts on a well-typed motive.
- **`obtain` → `.1`/`.2` projection.** To make the concrete goal's `base_change_mate_codomain_read`
  definitionally the variable-legs read, `base_change_mate_codomain_read`'s body was changed from
  `obtain ⟨…⟩ := pullback_fst_snd_specMap_tensor …` (a stuck `And.casesOn` that blocked the
  proof-irrelevant defeq) to `.1`/`.2` projections. The concrete `base_change_mate_fstar_reindex` is
  now `sorry`-free, reducing by `exact …_legs … (set_option maxHeartbeats 1600000 for the two
  change-of-rings dictionary unfoldings)`.
- **4 axiom-clean sub-lemmas closed:** `base_change_mate_codomain_read_legs`,
  `gammaMap_pushforwardComp_hom_eq_id`, `gammaMap_pushforwardComp_inv_eq_id`,
  `gammaMap_pushforwardCongr_hom` (the (ii) Γ-collapses: `(pushforwardComp a b).hom.app M = 𝟙 _` by
  `rfl`, then `Functor.map_id`).
- **Residual:** the lone step-(iii) mate-unwinding `sorry` inside `base_change_mate_fstar_reindex_legs`
  — rewrite the surviving `(g')`-unit by `key = pullbackPushforward_unit_comp`, absorb the `e`-unit as
  an iso, read the `Spec ιA`-unit via Seam 1 `base_change_mate_unit_value`, compose with the codomain
  read + `restrictScalars ψ` to land on `base_change_mate_inner_value`. Mathlib-absent categorical
  mate-unwinding, now isolated to a single concrete affine goal (no longer a motive wall).
- **Minor:** `gammaMap_pushforwardComp_hom_eq_id` does not fire under `simp` in the assembly position
  (discrimination-tree miss on the composed-functor source object); collapses in step (iii) once the
  unit factor is rewritten. Dropped from that `simp` arg to avoid the unused-arg lint.

### GF — L5 (`exists_free_localizationAway_polynomial`) — CLOSED, axiom-clean

The progress-critic's critical-watch (OreLocalization diamond, 2 consecutive iters, STUCK at iter-018
if unresolved) is defused.

- **Root cause:** `gf_torsion_reindex` returned its canonical `Module A_g T_g` (= `Localization.Away
  g`-action on `LocalizedModule (powers g) T`) as the **6th existential component** (filled by
  `inferInstance`). The use-site `obtain` destructured it into an **opaque local `hmod2`**. The carrier
  `LocalizedModule (powers h) T_g` is an `OreLocalization` quotient whose *type* depends on the `SMul
  A_g T_g` instance, so the IH output (over opaque `hmod2`) and `free_localizationAway_of_away_tower`'s
  `hfree` (over the freshly-synthesised canonical instance) were defeq-but-unmatched at instance
  transparency.
- **Fix (at the PRODUCER, per the iter-016 lesson):** drop the redundant 6th existential — it is always
  canonical (`inferInstance`), so bundling it only created the opaque fvar. `gf_torsion_reindex`
  signature loses the `(_ : Module (Localization.Away g) (LocalizedModule (powers g) T))` binder
  (retaining `hmod1` = `MvPolynomial (Fin m')`-action and `htower` = `IsScalarTower`, both genuinely
  non-canonical); use-site destructures the 7-tuple and lets `inferInstance` synthesise `Module A_g
  T_g` on both the IH path and the helper path — a single instance, no diamond.
- **Result:** L5 closes; `gf_torsion_reindex` re-verified axiom-clean after the signature
  simplification. **Lesson:** when a lemma returns a *canonical* (`inferInstance`) typeclass instance as
  an existential witness, destructuring it into an opaque local breaks downstream type-level instance
  matching on `OreLocalization`/`LocalizedModule` carriers — don't bundle canonical instances.
- **`lake env lean` vs `lake build` caveat reconfirmed:** single-file `lake env lean <file>` emits
  SPURIOUS instance-diamond errors (omits the lakefile `[leanOptions]`) that appear identically in the
  pre-edit baseline — they do NOT occur under `lake build <module>` and the LSP agrees with `lake
  build`. Already captured in user memory; reconfirmed authoritative here.

### QUOT — Route-2 first dispatch (`subquotient_degreewise_diff` + ambient calculus) — KEYSTONE LANDED

First prover lane since the iter-016 Route-2 pivot. **13 axiom-clean declarations, no `sorry`, no new
`maxHeartbeats`, no isDefEq/whnf pathology** — the HARD ENTRY CONSTRAINT (no
`DirectSum.Decomposition`/`IsInternal`/`map_iSup` on quotient/subtype carriers) held throughout,
validating Route-2's ambient-`M` architecture.

- **Keystone D6 `subquotient_degreewise_diff`** (`lem:graded_subquotient_degreewise_diff`) — the
  mathematically hardest *ambient* lemma, the `hdiff` input to `IsRatHilb.ofDiffEq`. Proved via a
  **single κ-linear map** `φ = N'.mkQ ∘ x ∘ subtype : ↥(N ⊓ ℳ n) →ₗ[κ] M ⧸ N'` (+ companion `g` on
  `T := (N ⊓ ℳ n).map x`): two rank-nullity identities, `ker` via `finrank_comap_subtype`, `range φ =
  range g`, inclusion-exclusion rewritten by the ambient image identity (`map_inf_degree_eq`) and
  distributive law (`sup_inf_degree_eq`); ℕ identity `c_{n+1}+k_n=a_n+b_{n+1}` by `omega`, ℚ assembly
  by `push_cast; linarith`. **The single-map route avoids `N' ≤ N`** and the blueprint's
  quotient-space `Q_n → Q_{n+1}` constructions.
- **`subquotientHilb`** (`def:graded_subquotientHilb`) — ambient dimension difference of the pair
  `(N, N')`. Realized as a function of `(N, N')` only (the endo-family + `Module.Finite` datum carried
  as induction-lemma hypotheses, not bundled — the Hilbert function genuinely depends only on `(N, N')`).
- **Ambient homogeneity calculus (11 aux decls):** `RaisesDegree` (predicate `∀ n, (ℳ n).map x ≤ ℳ
  (n+1)`), `RaisesDegree.mem`, the load-bearing `decompose_raisesDegree` (`↑(decompose ℳ (x m) (i+1)) =
  x ↑(decompose ℳ m i)`), `decompose_raisesDegree_zero`, `comap_isHomogeneous`, `map_isHomogeneous`,
  `inf_isHomogeneous`, `sup_isHomogeneous` (Mathlib has NO `Submodule.IsHomogeneous` lattice-closure),
  `map_inf_degree_eq`, `sup_inf_degree_eq`, `finrank_comap_subtype`.
- **Block — the finiteness encoding** (`subquotient_hilbertSeries_rational` P(r) induction +
  `subquotient_finite_transfer`): `Module.Finite (MvPolynomial (Fin r) κ) M` from `r` commuting
  degree-1 endos. Tool path scouted to the exact lemma (`Algebra.adjoinCommRingOfComm` + `aeval` into
  the CommRing adjoin + `Module.compHom` + `eval(t_{r-1}=0)` + `restrictScalars_of_surjective`); the
  subalgebra-only shortcut was ruled out (the smaller ring must be the *polynomial* ring, not
  `Algebra.adjoin`, or `restrictScalars_of_surjective` breaks). Deferred whole to keep the no-sorry
  invariant (a large self-contained build: a subquotient-datum `structure` + fresh module instances on
  K/C per IH step).

## Key findings / patterns discovered

1. **Subst-able free legs dissolve a "motive is not type correct" wall.** When a rewrite target sits in
   dependent positions (proof args, opaque def types), don't fight `rw`; restate the lemma with those
   targets as free variables and `subst`. Pair with `.1`/`.2` projections (not `obtain`) at the
   consumer to keep the defeq proof-irrelevant rather than a stuck `And.casesOn`.
2. **Don't bundle canonical (`inferInstance`) typeclass instances as existential witnesses** — the
   consumer's `obtain` makes them opaque fvars that break type-level instance matching on
   `OreLocalization`/`LocalizedModule` carriers. Bundle only genuinely non-canonical instances.
3. **Route-2 ambient-`M` architecture is sound and pathology-free.** Stating every graded object as
   `Naux ⊓ ℳ n` in the fixed ambient `M` (never on `↥p`/`M⧸p`) elaborated 13 decls with zero
   isDefEq/whnf runaway — the documented G2–G4 pathology did not fire even once.
4. **Single-κ-linear-map route for degreewise differences** avoids quotient-space constructions and
   `N' ≤ N` entirely.

## Subagent reports

See `recommendations.md` for landed findings (lean-auditor `iter017`; lean-vs-blueprint-checker `fbc` /
`gf` / `quot`). Reports under `.archon/task_results/`, archived to `logs/iter-017/`.

## Blueprint markers updated (manual)

- `Picard_FlatteningStratification.tex`, `lem:gf_torsion_reindex`: corrected the INTENDED LEAN
  SIGNATURE comment (~line 944) — replaced the now-removed redundant `(_ : Module (Localization.Away g)
  (LocalizedModule (powers g) T))` binder with a `% NOTE:` recording the iter-017 drop, matching the
  landed decl.
- No `\mathlibok` added (all 18 new decls are project lemmas, not Mathlib re-exports).
- No `\lean{...}` renames (closed targets kept their names; the new legs/Γ-collapse/ambient-calculus
  decls have no pins yet — coverage debt, listed in `recommendations.md`).
- No stale `\notready` to strip.
- `\leanok` on the closed proof blocks is owned by the deterministic `sync_leanok` (iter 17, sha
  ac7b842, added 3 / removed 0 — FBC + QuotScheme chapters).

## Low-impact notes

- The Seam-2 work introduced several `set_option maxHeartbeats 1600000` bumps for the change-of-rings
  dictionary unfoldings (honest; the `exact`-onto-`…_legs` certifies a proof-irrelevant defeq, not a
  loop). lean-auditor confirmation noted in `recommendations.md`.
- Long-line linter warnings (FlatBaseChange.lean ~1450/1475/1489/1491) — cosmetic, prover-cleanup.
