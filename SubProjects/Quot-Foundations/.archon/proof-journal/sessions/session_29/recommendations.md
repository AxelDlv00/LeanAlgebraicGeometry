# Recommendations for the next plan iteration (after iter-029)

## CRITICAL / HIGH — none
No must-fix-this-iter findings from any review subagent. Build GREEN, all new code axiom-clean.

## MEDIUM (act on these)

### 1. FBC `_legs` — STOP retrying any keyed-rewriting tactic. Assign the assembly proof term.
The prover **conclusively proved this iter** that `rw`/`simp`/`erw`/`conv`/`set`/`dsimp` ALL fail at the
`_legs` crux (@1446) — even a `rfl`-true fact whose LHS is the goal's own printed factor cannot be located
by `kabstract`, and even `rw [Category.comp_id]` cannot fire. **Do NOT re-dispatch with another rewriting
recipe variation** (this is the 5th+ iter of that family failing). The route is now pinned precisely:
- A single hand-built ~100–150 LOC proof term closed by ONE `exact`/`convert … using n`.
- Build each cancellation on a **separately-elaborated CLEAN term** (single instance in scope ⇒ no diamond),
  chain with `congrArg`/`Functor.congr_map`/`.trans`, touch the goal only at the final `exact`.
- All genuine-content helpers exist + proven: `_legs_gammaDistribute` (@1304),
  `inner_eCancel_eUnit`/`_pushforwardComp`/`_pullbackComp` (@1523/1535/1552), `unit_value` (@987).
- **Reversal/escalation signal**: if the prover reports the term-mode mechanism *itself* fails to fire
  (not "ran out of budget mid-chain"), escalate to an **effort-breaker** splitting `_legs` into per-atom
  sub-lemmas. This is the progress-critic's standing CHURNING tripwire — FBC has been PARTIAL for many iters;
  one more clean-but-unclosed iter should trigger the effort-breaker.
- Budget a dedicated iter for the assembly alone; validate one `.trans` link at a time on clean terms.
- `gstar_transpose` (@1818) cascades from `_legs` — do not assign separately yet.

### 2. QUOT gap1 — do NOT re-assign `isIso_fromTildeΓ_of_isQuasicoherent` directly. Build the transport first.
gap1 is blocked on a **genuine multi-iter Mathlib-absent sub-build**, not a one-tactic gap. The named
ingredient (from the prover) is:
- `restrictModulesToBasicOpen : (Spec R).Modules ⥤ (Spec R_r).Modules` (or the iso
  `(M.over (D r)) ≅ (pullback of M along D(r) ≅ Spec R_r)`) **+ Presentation-transport across it**.
- Aggravation: stating `q.presentation i` times out synthInstance (20000) on the slice
  `(sheafToPresheaf (J.over (q.X i)) _).IsRightAdjoint` — the slice route needs
  `set_option synthInstance.maxHeartbeats` + careful instance feeding even to typecheck.
- Recommend a **mathlib-analogist (api-alignment)** consult on whether Mathlib has ANY scheme-modules
  restriction/over↔pullback bridge before committing a from-scratch sub-build; if confirmed absent, an
  **effort-breaker** to split the transport into (a) slice-presentation restriction and (b) site-equivalence
  identification. With the transport in hand, the per-`r` localization follows from
  `isLocalizedModule_basicOpen_of_presentation` and `exists_finite_basicOpen_cover_le_quasicoherentData`
  (landed this iter) closes the Mayer–Vietoris loop.

### 3. Coverage debt — 1 unmatched `lean_aux` node needs a blueprint block (planner authors prose).
`archon dag-query unmatched` → 1 node:
- **`AlgebraicGeometry.exists_finite_basicOpen_cover_le_quasicoherentData`** (QuotScheme.lean:730, proved,
  axiom-clean). NO blueprint block. Add a sub-lemma in `Picard_QuotScheme.tex` near
  `lem:exists_isIso_fromTildeΓ_basicOpen_cover`, stating the basic-open finite-cover refinement of a
  `QuasicoherentData` cover (the topological precursor that drops the `IsIso fromTildeΓ` conclusion). It is a
  proper sub-statement. Its proof `\uses`: `Opens.grothendieckTopology`/`CoversTop`/`Sieve.ofObjects`
  membership, `isBasis_basic_opens`, `iSup_basicOpen_eq_top_iff'`, `Ideal.span_eq_top_iff_finite`. Pin
  `\lean{AlgebraicGeometry.exists_finite_basicOpen_cover_le_quasicoherentData}`.

### 4. QUOT blueprint — `lem:exists_isIso_fromTildeΓ_basicOpen_cover` pin points at a non-existent decl.
lean-vs-blueprint-checker `quot` (major): the blueprint block `lem:exists_isIso_fromTildeΓ_basicOpen_cover`
`\lean{}`-pins a Lean declaration that does not exist (and is the *stronger* `IsIso`-carrying statement, not
the topological precursor that was actually built). Have a blueprint-writer reconcile: either retarget the
pin to a planned name with a `% NOTE:` that the topological front is `exists_finite_basicOpen_cover_le_…`
and the full lemma awaits the transport, or split the block into precursor + full-lemma (recommended 3).

## LOW (notes)
- **QUOT (minor, lean-vs-blueprint-checker)**: 2 `private` decls (`bijective_comp_of_localizations`,
  `isIso_sheaf_of_isIso_app_basicOpen`) are pinned as public names in the blueprint, so their `\lean{}`
  pins won't resolve via tooling. Same pattern the FBC atoms had — consider de-privatizing them (a cheap
  prover rider) so pins resolve, like the 3 FBC atoms this iter. Not blocking.
- **QUOT (minor)**: `def:modules_annihilator` `\uses{}` overstates dependencies (includes lemmas only
  needed for the characterization, not the `ofIdeals` definition). Trim when next touching the chapter.
- **QUOT (major, pre-existing, already NOTE-flagged)**: `Grassmannian.representable` Lean statement
  (`∃ Y, Nonempty (RepresentableBy Y)`) is weaker than the blueprint prose (smooth projective, rel. dim.,
  tautological quotient, Plücker). Already acknowledged via `% NOTE:`; not new.
- **FBC (minor, lean-auditor)**: the new diagnosis box at @1416 uses editorial "definitive" language —
  cosmetic, no action needed.
- **GR lane produced no output this iter** — the `mathlib-build` cocycle/glued-scheme objective landed
  nothing. If re-dispatched, confirm the prover has a concrete ready target (the cocycle was reduced to a
  ring identity `Φ=id` in iter-028; check `def:gr_glued_scheme` is prover-ready before re-assigning).

## Reusable proof patterns discovered
- **Finite cover from a `QuasicoherentData`/`CoversTop` cover**: `q.coversTop ⊤ x trivial` +
  `Sieve.mem_ofObjects_iff` + `leOfHom` extracts a containing cover member; `Opens.isBasis_iff_nbhd.mp
  PrimeSpectrum.isBasis_basic_opens` refines to a basic open; `Ideal.span_eq_top_iff_finite` finitizes.
- **Diamond-bridging in `X.Modules`**: keyed rewriting is impossible under the category/comp instance
  diamond; the only working mechanism is whole-term defeq (`exact`/`convert`/`change`) on
  separately-elaborated clean terms chained by `congrArg`/`.trans`.
