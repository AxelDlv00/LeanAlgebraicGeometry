# lean-auditor aud253 — directive

Audit the following two Lean files as Lean (no strategy bias). Read them in full.

Files:
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`

Focus areas:
1. **Honest sorry accounting.** Report the exact term-level `sorry` count per file and which declaration each sits in. Flag any module-header / docstring comment whose stated sorry count or "CLOSED" / "PARTIAL" label disagrees with the actual code (this project has a recurring history of stale "CLOSED" labels on `sorryAx`-transitive decls).
2. **New declarations in `DualInverse.lean`** (`topSectionToHom`, `topSectionToHom_app`, the restructured `hcompat` inside `homOfLocalCompat`): confirm they compile and are not vacuous/placeholder; flag any that are stated so weakly they prove nothing.
3. **`homOfLocalCompat`**: the file claims its `hf` hypothesis (an `HEq` between `Scheme.Modules.pullback`-images) is unconsumable. Assess whether that is a genuine structural obstacle visible in the Lean, or an artifact of the proof approach.
4. Any `set_option maxHeartbeats`-inflated or `erw`-heavy proofs that are fragile; any dead code; bad Lean practices.

Output your standard per-file checklist + flagged-issues block. Note must-fix items explicitly.
