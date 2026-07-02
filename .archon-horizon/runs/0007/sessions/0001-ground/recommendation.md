# Recommendation for the first Horizon T8 agent

Task = close AJC in-tree v4.31.0 migration-interim `sorry`s by porting from green siblings. Signatures are **FROZEN** — repair proof bodies only.

## Order of attack (do the easy ports first, Cech last)

1. **`Picard/GlueDescent.lean` (3)** — GR-Quot-Closure sibling is green (`pullback_cast_compat` proved). Lift the bodies. Put `set_option backward.isDefEq.respectTransparency false in` BEFORE the docstring, not between docstring and `lemma`.
2. **`Picard/GrassmannianQuot.lean` (all 4: 813, 838, 2305, 3259)** — GR sibling is green (0 sorry). Task text says "only 2 + leave structural" but that is **stale**: all 4 are v4.31-tagged and there are no structural sorries here. Close all 4.
3. **`Picard/QuotScheme.lean` (2: 1716, 2242)** — GR sibling green; both are the `sheafToPresheaf.obj`/`Sheaf.forget`-vs-`.presheaf` defeq bridge. Leave the ~41 chi-blocked structural stubs alone.
4. **`Cohomology/CechHigherDirectImage.lean` (7)** — sibling `SubProjects/Cech-Cohomology/.../CechHigherDirectImage.lean` is green. `diff` the sorry regions and copy. `rawPushPullMap_comp` is pure **term-mode** (no `rw`, avoids "motive not type correct") — see memory `cech-gr-hard-sorrys-solved`. **Do this last** (see contention below).
5. **`Picard/SectionGradedRing.lean` (8)** — **BLOCKED, time-box.** GR sibling is RED (~8 hard v4.31 braided/monoidal compile errors, the `GRQ.graded` blocker) — no working port exists. Report the root cause (monoidal `LocalizedMonoidal`/braiding-naturality API migration), do not force it.

## Build contention — READ THIS

- A live T2/FBC `lake build` of `CechHigherDirectImageUnconditional` (imports `CechHigherDirectImage.lean`) is running in AJC's `.lake` (~2h as of session open, PID 419522).
- **Do NOT run a second `lake build` in AJC while it is alive** — two concurrent lake builds on the same project risk olean corruption (documented dead end).
- Edit the Picard/ files first (outside T2's cone). Before any verifying build, poll `ps -eo pid,cmd | grep lake` until the T2 build process has exited. Then run one build of the edited modules.
- Never edit `Cohomology/FlatBaseChange*` or `Cohomology/CechHigherDirectImageUnconditional.lean` (T2's exclusive write-scope).

## Done / verify

- Realistic outcome: **16/24 closed** (7+3+4+2), 8 SectionGradedRing documented-blocked.
- Verify with `lake build` of the affected modules + `#print axioms` clean (bar pre-existing typed-sorry carriers). Confirm signatures unchanged (`git diff` should show only proof-body deltas).
- LSP is dead on full-`import Mathlib` files here — iterate via `lake build <module>` reading the printed goal state.
