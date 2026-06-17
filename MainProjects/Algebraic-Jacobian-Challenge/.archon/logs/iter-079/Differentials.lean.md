# AlgebraicJacobian/Differentials.lean

## cotangentExactSeqAlpha.d_app (line 260, iter-077 internal sorry)

### Attempt 1 — ζ-bridge construction (PROGRESS.md route 1)
- **Approach:** Build a Y-presheaf bridge
  ```
  τ : (pullback g).obj S.presheaf ⟶ (pushforward f).obj ((pullback (f≫g)).obj S.presheaf)
  ```
  as
  ```
  τ := adj_g.homEquiv.symm (adj_fg.unit.app S.presheaf)
  ```
  (the dual of the η in `cotangentExactSeqBeta`). Then prove coherence
  ```
  τ ≫ (pushforward f).map φ_fg' = φ_g' ≫ f.c
  ```
  by injectivity of `adj_g.homEquiv` + two applications of
  `Adjunction.homEquiv_naturality_right`. Both sides collapse to `(f≫g).c`:
  - LHS becomes `adj_fg.unit.app S.presheaf ≫ (pushforward (f≫g)).map φ_fg'`
    which is rfl-equal to `adj_fg.homEquiv φ_fg' = (f≫g).c` via
    `Equiv.apply_symm_apply` on the definition of `φ_fg'`.
  - RHS becomes `g.c ≫ (pushforward g).map f.c` which equals `(f≫g).c` by
    the rfl-level scheme composition law (same identity used in β).

  Reading off the coherence at `(U, a)` gives
  ```
  (f.c.app U).hom (φ_g'.app U a) = (φ_fg'.app (op f⁻¹U)).hom ((τ.app U).hom a)
  ```
  so `D_X.d` of the LHS vanishes by `D_X.d_app`.

- **Result:** RESOLVED. Goal closed without sorry.
- **Key Mathlib leverage:**
  - `TopCat.Presheaf.pullbackPushforwardAdjunction` (the adjunction).
  - `Adjunction.homEquiv_naturality_right` (used twice — for τ-comp and for φ_g'-comp sides).
  - `Equiv.apply_symm_apply` (collapses the `homEquiv.symm` definitions of `φ_g'`, `φ_fg'`).
  - `PresheafOfModules.Derivation'.d_app` (kills the derivation on the φ_fg' image).
  - `(f≫g).c = g.c ≫ (pushforward g).map f.c` (rfl in current Mathlib — same identity exploited by β).
  - Pushforward composition `(pushforward g).map ∘ (pushforward f).map = (pushforward (f≫g)).map` (rfl).
- **Linter cleanup:** Two `show` tactics flagged by `linter.style.show` (they
  changed the goal rather than just annotated it); both replaced with `change`.

### Reproducibility
- File compiles with no errors (verified via `lean_diagnostic_messages`).
- 5 syntactic sorries remain (was 6): L113, L448, L735, L751, L895 — all upstream
  from this iter's scope.
- `lean_verify` on `cotangentExactSeqAlpha`: axiom profile identical to
  `cotangentExactSeqBeta` (`propext`, `sorryAx`, `Classical.choice`, `Quot.sound`).
  The `sorryAx` is inherited via the transitive dependency on
  `relativeDifferentialsPresheaf_isSheaf` (still sorry'd), not introduced by this
  closure.
- The four other `d_target` fields of `cotangentExactSeqAlpha` (`d`, `d_mul`,
  `d_map`, smul) are preserved byte-for-byte from iter-077.
- `set_option maxHeartbeats 16000000 in` on `cotangentExactSeqAlpha` preserved.

### Blueprint readiness
- `blueprint/src/chapters/Differentials.tex` definition `def:cotangent_alpha`
  already carries `\leanok` from iter-077 (it referred to the construction,
  which existed even with the internal sorry). The `sync_leanok` deterministic
  pass between prover and review will re-verify; no manual marker change needed.

## Other sorries (out of scope this iter, per PROGRESS.md)
- `relativeDifferentialsPresheaf_isSheaf` (L113)
- `cotangentExactSeq_structure` (L448) — gated on alpha+beta + stalkwise epi bridge (iter-079+)
- `smooth_iff_locally_free_omega` (L735)
- `cotangent_at_section` (L751)
- `serre_duality_genus` (L895)
